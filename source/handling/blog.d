module handling.blog;

import blog.uri;
import db.mongo;
import blog.post;
import vibe.http.server;    
import vibe.textfilter.markdown;
import blog.input;
import std.string;
import std.datetime;
import std.stdio;

void handleBlogRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    start();
    BlogPost post = getPostsFromLink(getNameFromURI(req.requestURI))[0];
    string name = post.name;
    string description = post.desc;
    string content = filterMarkdown(post.content);
    string date = post.date;
    int auth;
	if (req.session)
		auth = 1;
	if (req.session && req.session.get!string("isAdmin") == "true")
		auth = 2;
    res.render!("blog/blogfmt.dt",
                name, description, content, date, auth);
}

void handleBlogIndex(HTTPServerRequest req, HTTPServerResponse res)
{
    int auth;
	if (req.session)
		auth = 1;
	if (req.session && req.session.get!string("isAdmin") == "true")
		auth = 2;
    BlogPost[] blogs = getRecentBlogs();
    writeln(blogs);
    res.render!("blog.dt", blogs, auth);
}

void handleBlogEdit(HTTPServerRequest req, HTTPServerResponse res)
{
    if (!req.session && req.session.get!string("isAdmin") != "true")
        res.redirect("/");
    else
    {
        int auth;
        if (req.session)
            auth = 1;
        if (req.session && req.session.get!string("isAdmin") == "true")
		    auth = 2;
        writeln(req.requestURI);
        string uri = req.requestURI[11..$];//req.requestURI.split("/")[1..$];
        writeln(uri);
        BlogPost post = getPostsFromLink(uri)[0];
        writeln(post);
        string name = post.name;
        string description = post.desc;
        string content = post.content;
        writeln("rendering");
        res.render!("edit.dt", name, description, content, auth);
    }
}

void handleBlogRemove(HTTPServerRequest req, HTTPServerResponse res)
{
    if (!req.session || req.session.get!string("isAdmin") != "true")
        res.redirect("/");
    else
    {
        string uri = req.requestURI[13..$];
        writeln(uri);
        BlogPost post = getPostsFromLink(uri)[0];
        writeln(post);
        removePost(post);
    }
    res.redirect("/cp");
}

void createBlogPost(HTTPServerRequest req, HTTPServerResponse res)
{
    if (!req.session && req.session.get!string("isAdmin") != "true")
        res.redirect("/");
    else
    {
        string name = req.form["title"];
        string desc = req.form["description"];
        string content = req.form["body"];
        // string date = "null";
        string date = Clock.currTime().toSimpleString();
        string author = req.session.get!string("username");

        string link;
        foreach (c; name)
        {
            if (c == ' ')
                link ~= '_';
            else if (",.<>?;':\"[]{}()&*^%$#@`~".indexOf(c) < 0)
                link ~= c;
        }
        //posts are autoincremented
        BlogPost bp = {date, name, 0, desc, content, link, author};
        if (inputUserData(bp))
            res.redirect("blog/" ~ link);
        else
            res.redirect("cp/post");
    }
}

void editBlogPost(HTTPServerRequest req, HTTPServerResponse res)
{
    if (!req.session && req.session.get!string("isAdmin") != "true")
        res.redirect("/");
    else
    {
        string name = req.form["title"];
        string desc = req.form["description"];
        string content = req.form["body"];
        // string date = "null";
        string date = Clock.currTime().toSimpleString();
        string author = req.session.get!string("username");

        string link;
        foreach (c; name)
        {
            if (c == ' ')
                link ~= '_';
            else if (",.<>?;':\"[]{}()&*^%$#@`~".indexOf(c) < 0)
                link ~= c;
        }
        //posts are autoincremented
        BlogPost bp = {date, name, 0, desc, content, link, author};
        if (updateUserData(bp))
            res.redirect("blog/" ~ link);
        else
            res.redirect("cp/post");
    }
}
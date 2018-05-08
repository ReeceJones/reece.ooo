module handling.blog;

import blog.uri;
import blog.mongo;
import blog.post;
import vibe.http.server;    
import vibe.textfilter.markdown;
import blog.input;
import std.string;

void handleBlogRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    start();
    BlogPost post = getPostsFromLink(getNameFromURI(req.requestURI))[0];
    string name = post.name;
    string description = post.desc;
    string content = filterMarkdown(post.content);
    res.render!("blog/blogfmt.dt",
                name, description, content);
}

void createBlogPost(HTTPServerRequest req, HTTPServerResponse res)
{
    if (!req.session)
        res.redirect("/");
    else
    {
        string name = req.form["title"];
        string desc = req.form["description"];
        string content = req.form["body"];
        string date = "null";
        string link;
        foreach (c; name)
        {
            if (c == ' ')
                link ~= '_';
            else if (",.<>?;':\"[]{}()&*^%$#@`~".indexOf(c) < 0)
                link ~= c;
        }
        //posts are autoincremented
        BlogPost bp = {date, name, 0, desc, content, link};
        if (inputUserData(bp))
            res.redirect("blog/" ~ link);
        else
            res.redirect("cp/post");
    }
}

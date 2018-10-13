module handling.cp;

import vibe.http.server;
import std.conv: parse;
import blog.post;
import db.mongo;

void handleCPRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    if (!req.session)
        res.redirect("/login");
    else
    {
        string s = req.session.get!string("isAdmin");
        string username = req.session.get!string("username");
        BlogPost[] blogs = getPostsFromUser(username);
        bool isAdmin = parse!bool(s);
        res.render!("usercp.dt", isAdmin, username, blogs);
    }
}

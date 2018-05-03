module handling.cp;

import vibe.http.server;
import std.conv: parse;

void handleCPRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    if (!req.session)
        res.redirect("/");
    else
    {
        string s = req.session.get!string("isAdmin");
        bool isAdmin = parse!bool(s);
        res.render!("usercp.dt", isAdmin);
    }
}
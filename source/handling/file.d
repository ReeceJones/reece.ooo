module handling.file;
import vibe.core.path, vibe.http.server, vibe.http.fileserver, vibe.core.stream, vibe.core.file;
import std.file, std.stdio, std.string;
import defs;
import std.string: split;
import blog.uri, blog.post, blog.mongo;
import std.conv: parse;

void handleFilePath(HTTPServerRequest req, HTTPServerResponse res)
{
    auto resolvedPath = resolvePath(req.requestURI[1..$]);
    string filePath = resolvedPath.toString;
    writeln(filePath);
    //TODO: move these functions out of here
    if (filePath.exists == true)
    {
        sendFile(req, res, resolvedPath);
    }
    else if (req.requestURI == "/cp")
    {
        string s = req.session.get!string("isAdmin");
        bool isAdmin = parse!bool(s);
        writeln(s);
        res.render!("usercp.dt", isAdmin);
    }
    else if (req.requestURI.blogURI == true)
    {
        start();
        BlogPost post = getPostsFromName(getNameFromURI(req.requestURI))[0];
        string name = post.name;
        string description = post.desc;
        string content = post.content;
        res.render!("blog/blogfmt.dt",
                    name, description, content);
    }
}

private:

auto resolvePath(string req)
{
    return NativePath(rootPath ~ req);
}


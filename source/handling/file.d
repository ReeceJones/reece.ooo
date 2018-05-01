module handling.file;
import vibe.core.path, vibe.http.server, vibe.http.fileserver, vibe.core.stream, vibe.core.file;
import std.file, std.stdio, std.string;
import defs;
import std.string: split;
import blog.uri, blog.post, blog.mongo;

void handleFilePath(HTTPServerRequest req, HTTPServerResponse res)
{
    auto resolvedPath = resolvePath(req.requestURI[1..$]);
    string filePath = resolvedPath.toString;
    if (req.requestURI == "/")
    {
        res.render!("index.dt");
    }
    else if (req.requestURI == "/blog/")
    {
        res.render!("blog/index.dt");
    }
    else if (req.requestURI == "/l")
    {
        res.render!("login.dt");
    }
    else if (filePath.exists == true || req.requestURI == "/v.mp4")
    {
        sendFile(req, res, resolvedPath);
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
        writeln("requested blog api");
    }
}

private:

auto resolvePath(string req)
{
    return NativePath(rootPath ~ req);
}


module handling.file;
import vibe.core.path, vibe.http.server, vibe.http.fileserver, vibe.core.stream, vibe.core.file;
import std.file, std.stdio, std.string;
import defs;
import std.string: split;
import blog.uri;

void handleFilePath(HTTPServerRequest req, HTTPServerResponse res)
{
    auto resolvedPath = resolvePath(req.requestURI[1..$]);
    writeln("requested file: ", resolvedPath);
    writeln("raw request: ", req.requestURI);
    string filePath = resolvedPath.toString;
    if (req.requestURI == "/")
    {
        res.render!("index.dt");
    }
    else if (req.requestURI == "/blog/")
    {
        res.render!("blog/index.dt");
    }
    else if (filePath.exists == true)
    {
        sendFile(req, res, resolvedPath);
    }
    else if (req.requestURI.blogURI == true)
    {
        writeln("requested blog api");
    }
}

private:

auto resolvePath(string req)
{
    return NativePath(rootPath ~ req);
}


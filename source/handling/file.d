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
    if (filePath.exists == true)
    {
        sendFile(req, res, resolvedPath);
    }
}

private:

auto resolvePath(string req)
{
    return NativePath(rootPath ~ req);
}

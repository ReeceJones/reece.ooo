module handling.file;
import vibe.core.path, vibe.http.server, vibe.http.fileserver, vibe.core.stream;
import std.file, std.stdio, std.string;

immutable string rootPath = "/root/web/reece.ooo/public";

void handleFilePath(HTTPServerRequest req, HTTPServerResponse res)
{
    auto resolvedPath = resolvePath(req);
    writeln("requested file: ", resolvedPath);
    string filePath = resolvedPath.toString;
    if (filePath.exists == false)
    {
        writeln("[error] \"", filePath, "\" does not exist");
    }
    sendFile(req, res, resolvedPath);
}

private:

auto resolvePath(HTTPServerRequest req)
{
    return NativePath(rootPath ~ req.requestURI);
}

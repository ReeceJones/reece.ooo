module handling.file;
import vibe.core.path, vibe.http.server, vibe.http.fileserver, vibe.core.stream, vibe.core.file;
import std.file, std.stdio, std.string;
import defs;
import std.string: split;
import blog.uri;

void handleFilePath(HTTPServerRequest req, HTTPServerResponse res)
{
    auto resolvedPath = resolvePath(req);
    writeln("requested file: ", resolvedPath);
    string filePath = resolvedPath.toString;
    if (filePath.exists == false)
    {
        if (blogURI(req.requestURI) == true)
        {
            //sendFile(req, res, NativePath(rootPath ~ "/blog/blogfmt.html"));
            FileStream fs;
            ubyte[] content = cast(ubyte[])read(rootPath ~ "/blog/blogfmt.html");
            //find and replace the values relating to the blog
            uint stop = 0;
            while (cast(char)content[stop] != '\n')
                stop++;
            content = cast(ubyte[])("<script type=\"text/javascript\">var title = " ~ req.requestURI.split("/")[2] ~ "</script>");
            //fs.write(cast(ubyte[])read(rootPath ~ "/blog/blogfmt.html"));
            res.writeRawBody(fs);
        }
        else
            writeln("[error] \"", filePath, "\" does not exist");
    }
    sendFile(req, res, resolvedPath);
}

private:

auto resolvePath(HTTPServerRequest req)
{
    return NativePath(rootPath ~ req.requestURI);
}


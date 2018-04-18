module blog.uri;

import defs, std.stdio;
import std.string: split;

//check if a requested uri is a blog
bool blogURI(string reqURI)
{
    string[] items = reqURI.split("/");
    writeln(items);
    if (items[1] == "blog" && items.length > 2)
        return true;
    return false;
}

string getNameFromURI(string reqURI)
{
    string[] items = reqURI.split("/");
    return items[2];
}
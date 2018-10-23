module db.mongo;

import vibe.db.mongo.mongo;
import blog.post;
import std.conv: text, parse;
import defs;
import dauth;
import std.algorithm;
import std.stdio;
import std.range;
import std.traits;

void start()
{
    conn = connectMongoDB(mongoIP);
    users = conn.getCollection("auth.users");
    blogs = conn.getCollection("blogs.blogs");
}

bool checkPassword(string usr, string pwdRaw, out bool admin)
{
    auto q = users.find(Bson(["username" : Bson(usr)]));
    foreach (i, doc; q.byPair)
    {
        if (isSameHash(toPassword(cast(char[])pwdRaw), parseHash(cast(string)doc["password"])))
        {
            auto isAdmin = cast(string)doc["admin"];
            admin = parse!bool(isAdmin);
            return true;
        }
    }
    return false;
}

bool createUser(string user, string rawPWD, string isAdmin)
{
    bool exists = !users.find(Bson(["username" : Bson(user)])).empty;
    //could not create user
    if (exists == true)
        return false;
    string hashString = makeHash(toPassword(cast(char[])rawPWD)).toString();
    //now just need to insert into mongo
    users.insert(Bson([
        "username"  : Bson(user),
        "password"  : Bson(hashString),
        "admin"     : Bson(isAdmin)
    ]));
    return true;
}

void updateUserPWD(string user, string newPWD)
{
    string hashString = makeHash(toPassword(cast(char[])newPWD)).toString();
    users.update(Bson(
        ["username"  : Bson(user)]
    ),
    Bson(
        ["password"  : Bson(hashString)]
    ));
}

int getBlogNum()
{
    return cast(int)blogs.count("{}");
}

//TODO: make querying more modularized
// this function depends on the names of the variables so do something like name="best post ever"
public BlogPost[] getPosts(ALIASES...)()
{
    Bson[string] query;
    static foreach(i; ALIASES.length.iota)
    {
        string zz = __traits(identifier, ALIASES[i]);
        query[zz] = Bson(ALIASES[i]);
    }
    auto r = blogs.find(query);
    // convert each Bson object to a BlogPost struct
    BlogPost[] posts;
    foreach(doc; r)
    {
        //create a blogpost object using the query
        BlogPost t;
        //retrieve the items from the bson
        t.date = cast(string)doc["date"];
        t.name = cast(string)doc["name"];
        t.id = cast(double)doc["id"];
        t.desc = cast(string)doc["desc"];
        t.content = cast(string)doc["content"];
        t.link = cast(string)doc["link"];
        t.author = cast(string)doc["author"];
        //push into return array
        posts ~= t;
    }
    return posts;
}

BlogPost[] getPostsFromID(int id)
{
    static assert(__traits(identifier, id) == "id");
    return getPosts!(id)();
}
BlogPost[] getPostsFromUser(string author)
{
    static assert(__traits(identifier, author) == "author");
    return getPosts!(author)();
}

BlogPost[] getPostsFromName(string name)
{
    static assert(__traits(identifier, name) == "name");
    return getPosts!(name)();
}

BlogPost[] getPostsFromLink(string link)
{
    static assert(__traits(identifier, link) == "link");
    return getPosts!(link)();
}

//id is not needed, it will auto increment
bool createPost(BlogPost bp)
{
    bool exists = !blogs.find(Bson(["name" : Bson(bp.name)])).empty;
    //could not create user
    if (exists == true)
        return false;
    blogs.insert(Bson([
        "date" : Bson(bp.date),
        "name" : Bson(bp.name),
        "id"   : Bson(cast(double)getBlogNum()),
        "desc" : Bson(bp.desc),
        "content" : Bson(bp.content),
        "link" : Bson(bp.link),
        "author" : Bson(bp.author)
    ]));
    return true;
}

bool editPost(BlogPost bp)
{
    import std.stdio;
    bool exists = !blogs.find(Bson(["name" : Bson(bp.name)])).empty;
    //could not create user
    writeln(exists);
    if (exists == false)
        return false;
    blogs.update(
        Bson(["name" : Bson(bp.name)]),
        Bson([
        "date" : Bson(bp.date),
        "name" : Bson(bp.name),
        "id"   : Bson(cast(double)getBlogNum()),
        "desc" : Bson(bp.desc),
        "content" : Bson(bp.content),
        "link" : Bson(bp.link),
        "author" : Bson(bp.author)
    ]));
    return true;
}

BlogPost[] getRecentBlogs()
{
    start();
    auto q = blogs.find();
    BlogPost[] posts;
    foreach (i, doc; q.byPair)
    {
        writeln(i);
        //create a blogpost object using the query
        BlogPost t;
        //retrieve the items from the bson
        t.date = cast(string)doc["date"];
        t.name = cast(string)doc["name"];
        t.id = cast(double)doc["id"];
        t.desc = cast(string)doc["desc"];
        t.content = cast(string)doc["content"];
        t.link = cast(string)doc["link"];
        t.author = cast(string)doc["author"];
        posts ~= t;
    }
    writeln(posts);
    posts.sort!"a.id < b.id"();
    return posts;
}

private
{
    MongoClient conn;
    MongoCollection users;
    MongoCollection blogs;
}
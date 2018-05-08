module db.mongo;

import vibe.db.mongo.mongo;
import blog.post;
import std.conv: text, parse;
import defs;
import dauth;

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
BlogPost[] getPostsFromID(int id)
{
    auto q = blogs.find(Bson(["id" : Bson(id)]));
    BlogPost[] ret;
    foreach (i, doc; q.byPair)
    {
        //create a blogpost object using the query
        BlogPost t;
        //retrieve the items from the bson
        t.date = cast(string)doc["date"];
        t.name = cast(string)doc["name"];
        t.id = cast(int)doc["id"];
        t.desc = cast(string)doc["desc"];
        t.content = cast(string)doc["content"];
        t.link = cast(string)doc["link"];
        //push into return array
        ret ~= t;
    }
    return ret;
}

BlogPost[] getPostsFromName(string name)
{
    auto q = blogs.find(Bson(["name" : Bson(name)]));
        BlogPost[] ret;
    foreach (i, doc; q.byPair)
    {
        //create a blogpost object using the query
        BlogPost t;
        //retrieve the items from the bson
        t.date = cast(string)doc["date"];
        t.name = cast(string)doc["name"];
        t.id = cast(int)doc["id"];
        t.desc = cast(string)doc["desc"];
        t.content = cast(string)doc["content"];
        t.link = cast(string)doc["link"];
        //push into return array
        ret ~= t;
    }
    return ret;
}

BlogPost[] getPostsFromLink(string link)
{
    auto q = blogs.find(Bson(["link" : Bson(link)]));
        BlogPost[] ret;
    foreach (i, doc; q.byPair)
    {
        //create a blogpost object using the query
        BlogPost t;
        //retrieve the items from the bson
        t.date = cast(string)doc["date"];
        t.name = cast(string)doc["name"];
        t.id = cast(int)doc["id"];
        t.desc = cast(string)doc["desc"];
        t.content = cast(string)doc["content"];
        t.link = cast(string)doc["link"];
        //push into return array
        ret ~= t;
    }
    return ret;
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
        "id"   : Bson(getBlogNum()),
        "desc" : Bson(bp.desc),
        "content" : Bson(bp.content),
        "link" : Bson(bp.link)
    ]));
    return true;
}

private
{
    MongoClient conn;
    MongoCollection users;
    MongoCollection blogs;
}
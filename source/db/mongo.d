module db.mongo;

import vibe.db.mongo.mongo;
import blog.post;
import std.conv: text, parse;
import defs;
import dauth;

void start()
{
    conn = connectMongoDB(mongoIP);
    users = conn.getDatabase("auth")["users"];
    blogs = conn.getDatabase("blogs")["blogs"];
}

bool checkPassword(string usr, string pwdRaw, out bool admin)
{
    auto q = blogs.find(Bson(["username" : Bson(usr)]));
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

bool createUser(string user, string rawPWD)
{
    bool exists = !blogs.find(Bson(["username" : Bson(user)])).empty;
    //could not create user
    if (exists == true)
        return false;
    string hashString = makeHash(toPassword(cast(char[])rawPWD)).toString();
    //now just need to insert into mongo
    blogs.insert(Bson([
        "username"  : Bson(user),
        "password"  : Bson(hashString),
        "admin"     : Bson("false")
    ]));
    return true;
}

void updateUserPWD(string user, string newPWD)
{
    string hashString = makeHash(toPassword(cast(char[])newPWD)).toString();
    blogs.update(Bson(
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
        /*
            string date;
            string name;
            int id;
            string desc;
            string content;
            string link;
        */
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
        /*
            string date;
            string name;
            int id;
            string desc;
            string content;
            string link;
        */
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
        /*
            string date;
            string name;
            int id;
            string desc;
            string content;
            string link;
        */
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

//TODO: test to make sure this works
// BlogPost[] queryDB(string field, string value)
// {
//     auto q = blogs.find(Bson([field : Bson(value)]));
//     BlogPost[] ret;
//     foreach(i, doc; q.byPair)
//     {
//         writeln(doc.toJson.toString);
//         BlogPost t;
//         t.date = cast(string)doc["date"];
//         t.name = cast(string)doc["name"];
//         t.id = cast(double)doc["id"];
//         t.desc = cast(string)doc["desc"];
//         t.content = cast(string)doc["content"];
//         t.link = cast(string)doc["link"];
//         //push into return array
//         ret ~= t;
//     }
//     return ret;
// }

private
{
    MongoClient conn;
    MongoCollection users;
    MongoCollection blogs;
}
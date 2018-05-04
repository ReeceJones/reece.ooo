module blog.mongo;
import vibe.db.mongo.mongo;
import blog.post;
import std.conv: text;
import std.stdio: writeln;
import defs;

void start()
{
    conn = connectMongoDB(mongoIP);
    blogs = conn.getDatabase("blogs")["blogs"];
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
        //for debugging
        writeln(doc.toJson.toString);
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
        //for debugging
        writeln(doc.toJson.toString);
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
        //for debugging
        writeln(doc.toJson.toString);
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
void createPost(BlogPost bp)
{
    blogs.insert(Bson([
        "date" : Bson(bp.date),
        "name" : Bson(bp.name),
        "id"   : Bson(getBlogNum()),
        "desc" : Bson(bp.desc),
        "content" : Bson(bp.content),
        "link" : Bson(bp.link)
    ]));
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
    MongoCollection blogs;
}

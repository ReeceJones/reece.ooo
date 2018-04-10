module blog.mongo;
import vibe.db.mongo.mongo;
import blog.post;
import std.conv: text;
import std.stdio: writeln;

void start()
{
    conn = connectMongoDB("mongodb://localhost");
    blogs = conn.getCollection("blogs");
}

int getBlogNum()
{
    return cast(int)blogs.count("{}");
}

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
        t.id = cast(double)doc["id"];
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

private
{
    MongoClient conn;
    MongoCollection blogs;
}
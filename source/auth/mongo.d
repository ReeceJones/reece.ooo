module auth.mongo;
import vibe.db.mongo.mongo;
import blog.post;
import std.conv: text;
import std.stdio: writeln;
import defs;

void start()
{
    conn = connectMongoDB(mongoIP);
    blogs = conn.getDatabase("auth")["users"];
}

bool checkPassword(string usr, string pwdRaw)
{
    auto q = blogs.find(Bson(["username" : Bson(usr)]));
}

private
{
    MongoClient conn;
    MongoCollection blogs;
}
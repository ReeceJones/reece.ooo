module auth.mongo;
import vibe.db.mongo.mongo;
import blog.post;
import std.conv: text, parse;
import std.stdio: writeln;
import defs;
import dauth;

void start()
{
    conn = connectMongoDB(mongoIP);
    blogs = conn.getDatabase("auth")["users"];
}

bool checkPassword(string usr, string pwdRaw, out bool admin)
{
    auto q = blogs.find(Bson(["username" : Bson(usr)]));
    foreach (i, doc; q.byPair)
    {
        writeln(cast(string)doc["username"] ~ " : " ~ cast(string)doc["password"]);
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

private
{
    MongoClient conn;
    MongoCollection blogs;
}
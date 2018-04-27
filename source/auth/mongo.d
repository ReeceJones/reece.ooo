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
        if (validPWDHash(pwdRaw, cast(string)doc["password"]))
        {
            auto isAdmin = cast(string)doc["admin"];
            admin = parse!bool(isAdmin);
            return true;
        }
    }
    return false;
}

void createUser(string user, string rawPWD)
{
    string hashString = makeHash(toPassword(cast(char[])rawPWD)).toString();
    //now just need to insert into mongo
    blogs.insert(Bson([
        "username"  : Bson(user),
        "password"  : Bson(hashString),
        "admin"     : Bson("false")
    ]));
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
    bool validPWDHash(string rawPWD, string hashedPWD)
    {
        return isSameHash(toPassword(cast(char[])rawPWD), parseHash(hashedPWD));
    }
}
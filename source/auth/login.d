module auth.login;
import std.stdio;
import vibe.d;
import db.mongo;

void login(HTTPServerRequest req, HTTPServerResponse res)
{
    //make sure to check that a username and a password were supplied
    enforceHTTP("username" in req.form && "password" in req.form,
	 	HTTPStatus.badRequest, "Missing username/password field.");
    
    //start a session
	string username = req.form["username"];
    string password = req.form["password"];
	res.terminateSession();
    auto session = res.startSession();
    //have the username variable set in the session
    session.set("username", username);
    bool userIsAdmin;
    start();
    if (checkPassword(username, password, userIsAdmin))
    {
        //do any kind of authentification here
        if (userIsAdmin)
            session.set("isAdmin", "true");
        else
            session.set("isAdmin", "false");
    }
    else
        res.terminateSession();
    res.redirect("/cp");
}

void create(HTTPServerRequest req, HTTPServerResponse res)
{
    //make sure to check that a username and a password were supplied
    enforceHTTP("username" in req.form && "password" in req.form,
	 	HTTPStatus.badRequest, "Missing username/password field.");
    //start a session
	string username = req.form["username"];
    string password = req.form["password"];
    string isAdmin = "false";
    start();
    if (createUser(username, password, isAdmin) == false)
        res.redirect("/l");
    else
    {
        auto session = res.startSession();
        session.set("username", username);
        session.set("isAdmin", isAdmin);
        res.redirect("/cp");
    }
}

void logout(HTTPServerRequest req, HTTPServerResponse res)
{
	res.terminateSession();
    res.redirect("/");
}
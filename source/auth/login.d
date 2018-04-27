module auth.login;
import std.stdio;
import vibe.d;
import auth.mongo;

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
    if (checkPassword(username, password, userIsAdmin))
    {
        //do any kind of authentification here
        writeln("user " ~ username ~ " logged in\nisAdmin: " ~ userIsAdmin);

        //go to the main page
        res.redirect("/");
    }
    else
        res.terminateSession();
}

void create(HTTPServerRequest req, HTTPServerResponse res)
{
    //make sure to check that a username and a password were supplied
    enforceHTTP("username" in req.form && "password" in req.form,
	 	HTTPStatus.badRequest, "Missing username/password field.");
    
    //start a session
	string username = req.form["username"];
    string password = req.form["password"];
    createUser(username, password);
    res.redirect("/");
}

void logout(HTTPServerRequest req, HTTPServerResponse res)
{
	res.terminateSession();
    res.redirect("/");
}
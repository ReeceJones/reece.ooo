module auth.login;
import std.stdio;
import vibe.d;
import scrypt;

void login(HTTPServerRequest req, HTTPServerResponse res)
{
    //make sure to check that a username and a password were supplied
    enforceHTTP("username" in req.form && "password" in req.form,
	 	HTTPStatus.badRequest, "Missing username/password field.");
    
    //start a session
	string username = req.form["username"];
	res.terminateSession();
    auto session = res.startSession();
    //have the username variable set in the session
    session.set("username", username);

    //do any kind of authentification here
    writeln("user " ~ username ~ " logged in");

    //go to the main page
    res.redirect("/");
}

void logout(HTTPServerRequest req, HTTPServerResponse res)
{
	res.terminateSession();
    res.redirect("/");
}
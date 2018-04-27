import vibe.d;
import handling.file;
import blog.REST;
import defs;
import std.stdio;
import std.functional;
import auth.login;

shared static this()
{
	loadConfig();
	auto restSettings = new RestInterfaceSettings;
	restSettings.baseURL = URL("http://" ~ serverIP ~ ":8080");

	auto router = new URLRouter;
	router.get("/test.js", serveRestJSClient!BlogAPI(restSettings));
	router.get("*", &handleFilePath);

	router.post("/login", &login);
	router.post("/create", &create);
	router.post("/logout", &logout);

	router.registerRestInterface(new BlogAPI_impl, restSettings);

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "0.0.0.0"];
	settings.sessionStore = new MemorySessionStore;

	listenHTTP(settings, router);
}

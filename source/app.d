import vibe.d;
import handling.file;
import handling.blog;
import handling.cp;
import blog.REST;
import defs;
import std.stdio;
import std.functional;
import auth.login;

shared static this()
{
	//load our settings
	loadConfig();
	//rest api settings
	auto restSettings = new RestInterfaceSettings;
	restSettings.baseURL = URL("http://" ~ serverIP ~ ":8080");

	//url router setting
	auto router = new URLRouter;
	//get routes
	//rest api

	/*
		REST INTERFACE
	*/
	router.get("/blog.js", serveRestJSClient!BlogAPI(restSettings));

	/*
		STATIC PAGES
	*/
	router.get("/", staticTemplate!("index.dt"));
	router.get("/blog", staticTemplate!("blog.dt"));
	router.get("/blog/", staticTemplate!("blog.dt"));
	router.get("/l", staticTemplate!("login.dt"));
	router.get("/l/", staticTemplate!("login.dt"));
	router.get("/cp/post", staticTemplate!("post.dt"));
	router.get("/cp/post/", staticTemplate!("post.dt"));

	/*
		HANDLERS
	*/
	//any blog post is redirected to the handler
	router.get("/blog/*", &handleBlogRequest);
	//any control panel request is redirected to the handler
	router.get("/cp", &handleCPRequest);
	router.get("/cp/", &handleCPRequest);

	/*
		DEFAULT PATH
	*/
	router.get("*", &handleFilePath);

	//auth routes
	router.post("/login", &login);
	router.post("/create", &create);
	router.get("/logout", &logout);

	//register the rest interface
	router.registerRestInterface(new BlogAPI_impl, restSettings);

	//server settings
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "0.0.0.0"];
	
	//for sessions
	settings.sessionStore = new MemorySessionStore;

	listenHTTP(settings, router);
}

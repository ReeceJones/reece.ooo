import vibe.d;
import handling.file;
import handling.blog;
import handling.cp;
import defs;
import std.stdio;
import std.functional;
import auth.login;

// renders a page staticly, but passes the auth parameter
void semiStaticRender(string page)(HTTPServerRequest req, HTTPServerResponse res)
{
	writeln("semi-rendering!");
	int auth;
	if (req.session)
		auth = 1;
	if (req.session && req.session.get!string("isAdmin") == "true")
		auth = 2;
	writeln(auth);
	// = req.session && req.session.get!string("isAdmin") == "true";
	res.render!(page, auth);
}

shared static this()
{
	//load our settings
	loadConfig();
	//rest api settings
	auto restSettings = new RestInterfaceSettings;
	restSettings.baseURL = URL("https://reece.ooo");

	//url router setting
	auto router = new URLRouter;
	//get routes

	/*
		STATIC PAGES
	*/
	//router.get("/", staticTemplate!("index.dt"));
	router.get("/", &semiStaticRender!("index.dt"));
	// router.get("/blog", staticTemplate!("blog.dt"));
	// router.get("/blog/", staticTemplate!("blog.dt"));
	router.get("/login", &semiStaticRender!("login.dt"));
	router.get("/login/", &semiStaticRender!("login.dt"));
	router.get("/create", &semiStaticRender!("create.dt"));
	router.get("/create/", &semiStaticRender!("create.dt"));
	router.get("/cp/post", &semiStaticRender!("post.dt"));
	router.get("/cp/post/", &semiStaticRender!("post.dt"));

	/*
		HANDLERS
	*/
	router.get("/blog", &handleBlogIndex);
	router.get("/blog/", &handleBlogIndex);
	router.get("/blog/edit/*", &handleBlogEdit);
	router.get("/blog/remove/*", &handleBlogRemove);
	//any blog post is redirected to the handler
	router.get("/blog/*", &handleBlogRequest);
	//any control panel request is redirected to the handler
	router.get("/cp", &handleCPRequest);
	router.get("/cp/", &handleCPRequest);

	/*
		DEFAULT PATH
	*/
	router.get("*", &handleFilePath);

	/*
		AUTH ROUTES
	*/
	router.post("/login", &login);
	router.post("/create", &create);
	router.get("/logout", &logout);

	/*
		BLOG ROUTES
	*/
	router.post("/new_post", &createBlogPost);
	router.post("/edit_post", &editBlogPost);


	//server settings
	auto settings = new HTTPServerSettings;
	settings.port = 9001;
	settings.bindAddresses = ["::1", "0.0.0.0"];
	//for sessions
	settings.sessionStore = new MemorySessionStore;

	listenHTTP(settings, router);
}


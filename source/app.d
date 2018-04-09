import vibe.d;
import handling.file;
import blog.REST;

shared static this()
{
	auto restSettings = new RestInterfaceSettings;
	restSettings.baseURL = URL("http://localhost:8080/");

	auto router = new URLRouter;
	router.get("/test.js", serveRestJSClient!BlogAPI(restSettings));
	router.get("*", &handleFilePath);
	router.registerRestInterface(new BlogAPI_impl, restSettings);

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	
	listenHTTP(settings, router);
}

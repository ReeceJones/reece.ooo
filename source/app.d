import vibe.d;
import handling.file;
import blog.REST;
import defs;

shared static this()
{
	loadConfig();
	auto restSettings = new RestInterfaceSettings;
	restSettings.baseURL = URL("http://192.168.179.129:8080/");

	auto router = new URLRouter;
	router.get("/test.js", serveRestJSClient!BlogAPI(restSettings));
	router.get("*", &handleFilePath);
	router.registerRestInterface(new BlogAPI_impl, restSettings);

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "0.0.0.0"];
	
	listenHTTP(settings, router);
}

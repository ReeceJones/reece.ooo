module defs;
import pz.config;

PzConfig conf;

string rootPath;
string serverIP;
string mongoIP;
string userAdmin;
bool useCaptcha;

void loadConfig()
{
    conf = new PzConfig("settings.conf", true, true);
    rootPath = conf.getValue!string("publicPath");
    serverIP = conf.getValue!string("serverIP");
    mongoIP = "mongodb://" ~ conf.getValue!string("mongoIP");// ~ serverIP;
    userAdmin = conf.getValue!string("userAdmin");
    useCaptcha = conf.getValue!bool("useCaptcha");
}

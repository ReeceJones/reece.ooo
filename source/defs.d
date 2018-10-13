module defs;
import pz.config;

PzConfig conf;

string rootPath;
string serverIP;
string mongoIP;
string userAdmin;

void loadConfig()
{
    conf = new PzConfig("settings.conf", true, true);
    rootPath = conf.getValue!string("publicPath");
    serverIP = conf.getValue!string("serverIP");
    mongoIP = "mongodb://" ~ conf.getValue!string("mongoIP");// ~ serverIP;
    userAdmin = conf.getValue!string("userAdmin");
}

module defs;
import pz.config;

PzConfig conf;

string rootPath;
string serverIP;
int displayNumber;
string mongoIP;

void loadConfig()
{
    conf = new PzConfig("settings.conf", true, true);
    rootPath = conf.getValue!string("publicPath");
    serverIP = conf.getValue!string("serverIP");
    displayNumber = conf.getValue!int("displayNumber");
    mongoIP = "mongodb://" ~ serverIP;
}
module defs;
import pz.config;

PzConfig conf;

string rootPath;
string indexName;
string serverIP;
int displayNumber;

void loadConfig()
{
    conf = new PzConfig("settings.conf", true, true);
    rootPath = conf.getValue!string("publicPath");
    indexName = conf.getValue!string("indexName");
    serverIP = conf.getValue!string("serverIP");
    displayNumber = conf.getValue!int("displayNumber");
}
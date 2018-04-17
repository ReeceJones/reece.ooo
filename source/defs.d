module defs;
import pz.config;

PzConfig conf;

string rootPath;
string indexName;
string serverIP;

void loadConfig()
{
    conf = new PzConfig("settings.conf", true, true);
    rootPath = conf.getValue!string("publicPath");//"/root/web/reece.ooo/public";
    indexName = conf.getValue!string("indexName");
    serverIP = conf.getValue!string("serverIP");
}
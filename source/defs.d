module defs;
import pz.config;

PzConfig conf;

string rootPath;

void loadConfig()
{
    conf = new PzConfig("settings.conf", true, true);
    rootPath = conf.getValue!string("publicPath");//"/root/web/reece.ooo/public";
}
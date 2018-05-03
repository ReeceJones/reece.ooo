module handling.blog;

import blog.uri;
import blog.mongo;
import blog.post;
import vibe.http.server;

void handleBlogRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    start();
    BlogPost post = getPostsFromName(getNameFromURI(req.requestURI))[0];
    string name = post.name;
    string description = post.desc;
    string content = post.content;
    res.render!("blog/blogfmt.dt",
                name, description, content);
}
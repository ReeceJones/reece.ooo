module blog.REST;

import vibe.web.rest;
import blog.post;
import blog.mongo;
import std.stdio;


@path("/api/")
interface BlogAPI
{
    // GET /api/post
    BlogPost[] getRecentBlogs();
}

class BlogAPI_impl : BlogAPI
{
public:
    BlogPost[] getRecentBlogs()
    {
	writeln("called");
        start();
        auto n = getBlogNum();
	writeln("number of blogs: ", n);
        BlogPost[] blogs;
	BlogPost tmp = {"never", "name", 0, "desc", "content", "link"};
	blogs ~= tmp;
    for (int i = n - 1; i < n; i++)
    {
        if (i < 0)
            break;
        blogs ~= getPostsFromID(i)[0];
    }
    return blogs;
    }
}

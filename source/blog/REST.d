module blog.REST;

import vibe.web.rest;
import blog.post;
import blog.mongo;

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
        start();
        auto n = getBlogNum();
        BlogPost[] blogs;
        for (int i = n - 1; i < n; i++)
        {
            if (i < 0)
                break;
            blogs ~= getPostsFromID(i)[0];
        }
        return blogs;
    };
}
module blog.REST;

import blog.post;
import db.mongo;
import std.stdio;
import defs;

import blog.input;


// BlogPost[] getRecentBlogs()
// {
//     start();
//     auto n = getBlogNum();
//     BlogPost[] blogs;
//     for (int i = 0; i < n; i++)
//     {
//         //2 - 0 - 1
//         //2 - 1 - 1
//         if (n - i - 1 < 0)
//             continue;
//         blogs ~= getPostsFromID(n - i - 1)[0];
//     }
//     return blogs;
// }
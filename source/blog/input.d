module blog.input;
import blog.mongo;
import blog.post;

bool inputUserData(BlogPost bp)
{
    start();
    return createPost(bp);
}
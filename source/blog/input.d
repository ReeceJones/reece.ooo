module blog.input;
import db.mongo;
import blog.post;

bool inputUserData(BlogPost bp)
{
    start();
    return createPost(bp);
}

bool updateUserData(BlogPost bp)
{
    start();
    return editPost(bp);
}
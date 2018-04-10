module blog.post;

struct BlogPost
{
    string date;
    string name;
    double id;
    string desc;
    string content;
    string link;
}

/*
db.createUser({
    "user":"user",
    "pwd": "password",
    "roles": ["readWrite", "dbAdmin"]
});

db.createCollection('blogs');

db.blogs.insert({
    "date": "never",
    "name": "test",
    "id": 0,
    "desc": "This is a simple description of a blog post",
    "content": "This is some content inside of a blog post. Right now there is not much here but eventually more will be added",
    "link": "post.html"
});
*/
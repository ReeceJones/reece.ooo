# reece.ooo
This is my website. It uses vibe.d as a webserver framework, along with its auto-generating REST interface feature for blog posts.
# Building
Building the site is easy. Just open terminal and go to the base directory and enter the following command: `dub build --build=release --arch=x86_64`
# Dependencies
+ dub
+ vibe.d
+ jquery 3.3.1
+ animate.css
+ MongoDB
# Install Notes
I'm not exactly sure why, but make sure in the MongoDB config you have `bindIp` set to `0.0.0.0`.

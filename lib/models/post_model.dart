// @dart=2.0
class Post {
  String typeimage;
  List<dynamic> dimensions;
  String id;
  String display_url;
  String text;
  bool is_video;
  String username;
  List<String> hashtags;
  String profile_pic;

  // Perhaps some more

  Post(this.typeimage, this.dimensions, this.id, this.display_url, this.text,
      this.is_video, this.username, this.hashtags, this.profile_pic);

  Post.fromMap(Map<String, dynamic> map) {
    typeimage = map['_typeimage'];
    dimensions = map['dimensions'];
    id = map['id'];
    display_url = map['display_url'];
    text = map['text'];
    is_video = map['is_video'];
    username = map['username'];
    hashtags = map['hashtags'];
    profile_pic = map['profile_pic'];
  }
}

class PostRepost {
  List<Post> posts;
  int totalPosts;
  int pageNumber;
  int pageSize;

  // Perhaps some more

  PostRepost({this.posts, this.totalPosts, this.pageNumber, this.pageSize});

  PostRepost.fromMap(Map<String, dynamic> map)
      : posts = new List<Post>.from(
            map['posts'].map((post) => new Post.fromMap(post))),
        totalPosts = map['totalPosts'],
        pageNumber = map['pageNumber'],
        pageSize = map['pageSize'];
}

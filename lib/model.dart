import 'dart:convert';

class User {
  String id;
  String username;
  String email;
  String password;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "password": password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, password: $password}';
  }
}

List<User> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<User>.from(data['users'].map((item) => User.fromJson(item)));
}

String userToJson(User data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class News {
  String id;
  String title;
  String content;
  String imageUrl;
  String publishedDate;
  String updatedDate;
  String kategori;
  String author;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedDate,
    required this.updatedDate,
    required this.kategori,
    required this.author,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
      publishedDate: json['published_date'],
      updatedDate: json['updated_date'],
      kategori: json['kategori'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "image_url": imageUrl,
      "published_date": publishedDate,
      "updated_date": updatedDate,
      "kategori": kategori,
      "author": author,
    };
  }

  @override
  String toString() {
    return 'News{id: $id, title: $title, content: $content, image_url: $imageUrl, published_date: $publishedDate, updated_date: $updatedDate, kategori: $kategori, author: $author}';
  }
}

List<News> newsFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<News>.from(data['news'].map((item) => News.fromJson(item)));
}

String newsToJson(News data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

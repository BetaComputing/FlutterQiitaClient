class Article {
  const Article(this.id, this.url, this.title, this.authorId,
      this.authorIconUrl, this.createdAt, this.tags, this.likes);

  final String id;
  final String url;
  final String title;
  final String authorId;
  final String authorIconUrl;
  final DateTime createdAt;
  final List<String> tags;
  final int likes;

  @override
  String toString() => 'Article('
      'id=${this.id}, '
      'url=${this.url}, '
      'title=${this.title}, '
      'authorId=${this.authorId}, '
      'authorIconUrl=${this.authorIconUrl}, '
      'createdAt=${this.createdAt}, '
      'tags=[${this.tags.join(", ")}], '
      'likes=${this.likes}'
      ')';

  static Article fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final tags = (json['tags'] as List)
        .map((dynamic e) => e as Map<String, dynamic>)
        .map((e) => e['name'] as String)
        .toList(growable: false);

    return Article(
        json['id'] as String,
        json['url'] as String,
        json['title'] as String,
        user['id'] as String,
        user['profile_image_url'] as String,
        DateTime.parse(json['created_at'] as String).toLocal(),
        tags,
        json['likes_count'] as int);
  }
}

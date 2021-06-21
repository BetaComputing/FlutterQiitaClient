import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.freezed.dart';

/// 記事データ
@freezed
class Article with _$Article {
  const factory Article({
    /// 記事のID
    required String id,

    /// 記事のURL
    required String url,

    /// 記事のタイトル
    required String title,

    /// 著者のID
    required String authorId,

    /// 著者のアイコンのURL
    required String authorIconUrl,

    /// 記事の作成日時
    required DateTime createdAt,

    /// 記事のタグのリスト
    required List<String> tags,

    /// いいねの数
    required int likes,
  }) = _Article;

  /// 記事データをJSONから生成する。
  static Article fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final tags = (json['tags'] as List)
        .map((dynamic e) => e as Map<String, dynamic>)
        .map((e) => e['name'] as String)
        .toList(growable: false);

    return Article(
      id: json['id'] as String,
      url: json['url'] as String,
      title: json['title'] as String,
      authorId: user['id'] as String,
      authorIconUrl: user['profile_image_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      tags: tags,
      likes: json['likes_count'] as int,
    );
  }
}

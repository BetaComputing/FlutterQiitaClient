import 'dart:convert';
import 'dart:io';
import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/article/article_repository.dart';
import 'package:http/http.dart' as http;

class ArticleRepositoryImpl implements ArticleRepository {
  ArticleRepositoryImpl(String token) : _token = token;
  final String _token;

  @override
  Future<ArticleSearchResult> search(String keyword) async {
    final uri = _buildUri(keyword);
    final headers = {'Authorization': 'Bearer $_token'};

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        return ArticleSearchFailure(
          HttpException('HTTP ${response.statusCode}'),
        );
      }

      final list = _parseArticleList(response.body);

      return ArticleSearchSuccess(list);
    } on Exception catch (ex) {
      return ArticleSearchFailure(ex);
    }
  }

  //  コールを行うURIを組み立てる。
  Uri _buildUri(String keyword) {
    final encodedKeyword = Uri.encodeQueryComponent(keyword);
    final params = <String, dynamic>{
      'page': 1.toString(),
      'per_page': 20.toString(),
      'query': 'title:$encodedKeyword',
    };

    return Uri.https('qiita.com', 'api/v2/items', params);
  }

  //  記事リストをパースする。
  List<Article> _parseArticleList(String body) {
    final json = (jsonDecode(body) as List).cast<Map<String, dynamic>>();
    final list = json.map((j) => Article.fromJson(j)).toList();

    return list;
  }
}

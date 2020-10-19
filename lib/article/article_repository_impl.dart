import 'dart:convert';
import 'dart:io';
import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/article/article_repository.dart';
import 'package:http/http.dart' as http;

class ArticleRepositoryImpl implements ArticleRepository {
  ArticleRepositoryImpl(String token) : this._token = token;
  final String _token;

  @override
  Future<ArticleSearchResult> search(String keyword) async {
    final url = this._buildUrl(keyword);
    final headers = {'Authorization': 'Bearer ${this._token}'};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode != 200) {
        return ArticleSearchFailure(
          HttpException('HTTP ${response.statusCode}'),
        );
      }

      final list = this.parseArticleList(response.body);

      return ArticleSearchSuccess(list);
    } on Exception catch (ex) {
      return ArticleSearchFailure(ex);
    }
  }

  //  コールを行うURLを組み立てる。
  String _buildUrl(String keyword) {
    final encodedKeyword = Uri.encodeQueryComponent(keyword);
    const endpoint = 'https://qiita.com/api/v2/items';
    final params = 'page=1&per_page=20&query=title:$encodedKeyword';
    final url = '$endpoint?$params';

    return url;
  }

  //  記事リストをパースする。
  List<Article> parseArticleList(String body) {
    final json = (jsonDecode(body) as List).cast<Map<String, dynamic>>();
    final list = json.map((j) => Article.fromJson(j)).toList();

    return list;
  }
}

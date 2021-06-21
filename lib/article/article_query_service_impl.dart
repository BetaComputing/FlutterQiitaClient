import 'dart:convert';
import 'dart:io';

import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/article/article_query_service.dart';
import 'package:http/http.dart' as http;

//  記事のクエリサービスの実装
class ArticleQueryServiceImpl implements ArticleQueryService {
  ArticleQueryServiceImpl(this._token);

  //  1度に取得する件数
  static const int _perPage = 20;

  //  APIのトークン
  final String _token;

  @override
  Future<ArticleSearchResult> search(String keyword) async {
    final uri = _buildUri(keyword);
    final headers = {'Authorization': 'Bearer $_token'};

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw HttpException('HttpException(${response.statusCode})', uri: uri);
      }

      final list = _parseArticleList(response.body);

      return ArticleSearchResult.success(list);
    } on SocketException catch (e) {
      print('クライアントエラー: $e');

      return ArticleSearchResult.clientError(e);
    } on HttpException catch (e) {
      print('@サーバエラー: $e');

      return ArticleSearchResult.serverError(e);
    }
  }

  //  コールを行うURIを組み立てる。
  Uri _buildUri(String keyword) {
    final encodedKeyword = Uri.encodeQueryComponent(keyword);
    final params = <String, dynamic>{
      'page': 1.toString(),
      'per_page': _perPage.toString(),
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

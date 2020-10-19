import 'package:flutter_qiita_client/article/article.dart';

//  Qiita記事のリポジトリ
abstract class ArticleRepository {
  //  記事を検索する。
  Future<ArticleSearchResult> search(String keyword);
}

//  記事の検索結果
abstract class ArticleSearchResult {}

//  記事の検索結果 (成功)
class ArticleSearchSuccess extends ArticleSearchResult {
  ArticleSearchSuccess(this.articles);

  //  取得された記事リスト
  final List<Article> articles;
}

//  記事の検索結果 (失敗)
class ArticleSearchFailure extends ArticleSearchResult {
  ArticleSearchFailure(this.exception);

  //  発生した例外
  final Exception exception;
}

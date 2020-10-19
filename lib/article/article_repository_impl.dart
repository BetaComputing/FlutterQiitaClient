import 'package:flutter_qiita_client/article/article_repository.dart';
import 'package:flutter_qiita_client/article/dummy_article.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  ArticleRepositoryImpl(String token) : this._token = token;
  final String _token;

  @override
  Future<ArticleSearchResult> search(String keyword) async {
    // TODO(Someone): ちゃんと実装する。

    print(this._token);
    await Future<void>.delayed(const Duration(seconds: 3));

    final dummy = Iterable.generate(3, (_) => const DummyArticle()).toList();
    final result = ArticleSearchSuccess(dummy);

    return result;
  }
}

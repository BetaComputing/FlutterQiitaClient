import 'package:flutter_qiita_client/article/article.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_query_service.freezed.dart';

/// Qiita記事のクエリサービス
abstract class ArticleQueryService {
  /// 記事を検索する。
  Future<ArticleSearchResult> search(String keyword);
}

/// 記事の検索結果
@freezed
class ArticleSearchResult with _$ArticleSearchResult {
  /// 成功
  const factory ArticleSearchResult.success(List<Article> articles) = _Success;

  /// クライアント側のエラー
  /// (オフライン時など)
  const factory ArticleSearchResult.clientError(Exception e) = _ClientError;

  /// サーバ側のエラー
  /// (レスポンスが200番台以外など)
  const factory ArticleSearchResult.serverError(Exception e) = _ServerError;
}

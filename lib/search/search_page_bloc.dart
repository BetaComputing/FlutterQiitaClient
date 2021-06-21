import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/article/article_query_service.dart';
import 'package:flutter_qiita_client/search/search_page.dart';
import 'package:rxdart/rxdart.dart';

/// 検索ページのBLoC
class SearchPageBloc {
  SearchPageBloc(this._queryService) {
    search();
  }

  final ArticleQueryService _queryService;

  //  検索キーワード
  final _keyword = BehaviorSubject.seeded('');

  //  読み込み中かどうか
  final _isLoading = BehaviorSubject.seeded(false);

  //  記事リスト
  final _articleList = BehaviorSubject<List<Article>?>.seeded(null);

  //  エラー
  final _error = PublishSubject<ErrorType>();

  /// 検索キーワード
  Stream<String> get keyword => _keyword.stream;

  /// 検索キーワードのSink
  Sink<String> get keywordSink => _keyword.sink;

  /// 読み込み中かどうか
  Stream<bool> get isLoading => _isLoading.stream;

  /// 記事リスト
  /// (エラー時はnullを通知する。)
  Stream<List<Article>?> get articleList => _articleList.stream;

  /// エラー
  Stream<ErrorType> get error => _error.stream;

  /// 検索を行う。
  Future<void> search() async {
    //  すでに処理中ならば処理を行わない。
    if (_isLoading.value) return;

    //  読み込みを開始する。
    _isLoading.value = true;

    //  検索処理を走らせる。
    await _search();

    //  読み込みを終了する。
    _isLoading.value = false;
  }

  /// リフレッシュを行う。
  Future<void> refresh() async {
    //  すでに処理中ならば処理を行わない。
    if (_isLoading.value) return;

    //  検索処理を走らせる。
    await _search();
  }

  /// 終了処理を行う。
  void dispose() {
    _keyword.close();
    _isLoading.close();
    _articleList.close();
    _error.close();
  }

  //  検索処理を行い、結果をUIに反映させる。
  Future<void> _search() async {
    //  検索処理を行う。
    final keyword = _keyword.value;
    final result = await _queryService.search(keyword);

    //  検索結果を反映させる。
    result.when(
      success: (articles) {
        _articleList.value = articles;
      },
      clientError: (e) {
        _articleList.value = null;
        _error.add(ErrorType.clientError);
      },
      serverError: (e) {
        _articleList.value = null;
        _error.add(ErrorType.serverError);
      },
    );
  }
}

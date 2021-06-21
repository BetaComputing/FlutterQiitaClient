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

class SearchPageBloc2 {
  SearchPageBloc2(this._queryService) {
    _searchEventSubject.listen((_) => _search());
  }

  final ArticleQueryService _queryService;

  final _articleListSubject = BehaviorSubject.seeded(List<Article>.empty());
  final _isFetchingSubject = BehaviorSubject.seeded(false);
  final _keywordSubject = BehaviorSubject.seeded('');
  final _searchEventSubject = PublishSubject<void>();

  /// 記事リストを通知するStream
  Stream<List<Article>> get articleList => _articleListSubject.stream;

  /// 取得中かどうかを通知するStream
  Stream<bool> get isFetching => _isFetchingSubject.stream;

  /// 検索キーワードを流すSink
  Sink<String> get keywordSink => _keywordSubject.sink;

  /// 検索ボタンが有効かどうかを通知するStream
  Stream<bool> get isSearchButtonEnabled =>
      Rx.combineLatest2<String, bool, bool>(
        _keywordSubject,
        isFetching,
        (keyword, isFetching) => keyword.isNotEmpty && !isFetching,
      );

  /// 検索が要求されたことを流すSink
  Sink<void> get searchEvent => _searchEventSubject.sink;

  /// 終了処理を行う。
  void dispose() {
    _articleListSubject.close();
    _isFetchingSubject.close();
    _keywordSubject.close();
    _searchEventSubject.close();
  }

  //  検索を行う。
  Future<void> _search() async {
    _isFetchingSubject.value = true;

    final keyword = _keywordSubject.value;
    final result = await _queryService.search(keyword);

    result.when(
      success: (articles) => _articleListSubject.value = articles,
      clientError: (e) {
        //  TODO: エラー処理
      },
      serverError: (e) {
        //  TODO: エラー処理
      },
    );

    _isFetchingSubject.value = false;
  }
}

import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/article/article_query_service.dart';
import 'package:rxdart/rxdart.dart';

/// 検索ページのBLoC
class SearchPageBloc {
  SearchPageBloc(this._queryService) {
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

import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/article/dummy_article.dart';
import 'package:rxdart/rxdart.dart';

class SearchPageBloc {
  SearchPageBloc() {
    this._searchEventSubject.listen((_) => this._search());
  }

  final _articleListSubject = BehaviorSubject.seeded(List<Article>.empty());
  final _isFetchingSubject = BehaviorSubject.seeded(false);
  final _keywordSubject = BehaviorSubject.seeded('');
  final _searchEventSubject = PublishSubject<void>();

  //  記事リストを通知するStream
  Stream<List<Article>> get articleList => this._articleListSubject.stream;

  //  取得中かどうかを通知するStream
  Stream<bool> get isFetching => this._isFetchingSubject.stream;

  //  検索キーワードを流すSink
  Sink<String> get keywordSink => this._keywordSubject.sink;

  //  検索ボタンが有効かどうかを通知するStream
  Stream<bool> get isSearchButtonEnabled => Rx.combineLatest2(
        this._keywordSubject,
        this.isFetching,
        (String keyword, bool isFetching) => keyword.isNotEmpty && !isFetching,
      );

  //  検索が要求されたことを流すSink
  Sink<void> get searchEvent => this._searchEventSubject.sink;

  void dispose() {
    this._articleListSubject.close();
    this._isFetchingSubject.close();
    this._keywordSubject.close();
    this._searchEventSubject.close();
  }

  //  検索を行う。
  Future<void> _search() async {
    this._isFetchingSubject.add(true);

    // TODO(Someone): リポジトリのコールを実装する。
    await Future<void>.delayed(const Duration(seconds: 3));
    final dummy = Iterable.generate(20, (_) => const DummyArticle()).toList();
    this._articleListSubject.add(dummy);

    this._isFetchingSubject.add(false);
  }
}

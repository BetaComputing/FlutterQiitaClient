import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/article/article_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchPageBloc {
  SearchPageBloc(ArticleRepository repository) : _repository = repository {
    _searchEventSubject.listen((_) => _search());
  }

  final ArticleRepository _repository;

  final _articleListSubject = BehaviorSubject.seeded(List<Article>.empty());
  final _isFetchingSubject = BehaviorSubject.seeded(false);
  final _keywordSubject = BehaviorSubject.seeded('');
  final _searchEventSubject = PublishSubject<void>();

  //  記事リストを通知するStream
  Stream<List<Article>> get articleList => _articleListSubject.stream;

  //  取得中かどうかを通知するStream
  Stream<bool> get isFetching => _isFetchingSubject.stream;

  //  検索キーワードを流すSink
  Sink<String> get keywordSink => _keywordSubject.sink;

  //  検索ボタンが有効かどうかを通知するStream
  Stream<bool> get isSearchButtonEnabled => Rx.combineLatest2(
        _keywordSubject,
        isFetching,
        (String keyword, bool isFetching) => keyword.isNotEmpty && !isFetching,
      );

  //  検索が要求されたことを流すSink
  Sink<void> get searchEvent => _searchEventSubject.sink;

  void dispose() {
    _articleListSubject.close();
    _isFetchingSubject.close();
    _keywordSubject.close();
    _searchEventSubject.close();
  }

  //  検索を行う。
  Future<void> _search() async {
    _isFetchingSubject.add(true);

    final result = await _repository.search(_keywordSubject.value);

    //  成功したとき。
    if (result is ArticleSearchSuccess) {
      _articleListSubject.add(result.articles);
    }

    //  失敗したとき。
    else if (result is ArticleSearchFailure) {
      print('ERROR: ${result.exception}');
    }

    _isFetchingSubject.add(false);
  }
}

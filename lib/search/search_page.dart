import 'package:flutter/material.dart';
import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/dependency.dart';
import 'package:flutter_qiita_client/search/article_view.dart';
import 'package:flutter_qiita_client/search/search_page_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

/// 検索ページ
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<SearchPageBloc>(
      create: (context) => SearchPageBloc(Dependency.resolve()),
      dispose: (context, bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          final bloc = Provider.of<SearchPageBloc>(context);

          return _SearchPage(bloc);
        },
      ),
    );
  }
}

/// 検索ページのエラー種類
enum ErrorType {
  /// クライアント側のエラー
  clientError,

  /// サーバ側のエラー
  serverError,
}

//  検索ページの実装
class _SearchPage extends StatefulWidget {
  const _SearchPage(this.bloc);

  final SearchPageBloc bloc;

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

//  検索ページの実装のState
class _SearchPageState extends State<_SearchPage> {
  //  読み込み中のインジケータ
  static const _loadingIndicator = Center(child: CircularProgressIndicator());

  //  BLoCへのショートカット
  SearchPageBloc get bloc => widget.bloc;

  //  Streamの購読のまとまり
  final compositeSubscription = CompositeSubscription();

  //  キーワードのコントローラ
  late final TextEditingController keywordController;

  @override
  void initState() {
    super.initState();

    keywordController = TextEditingController();

    //  検索キーワードを購読する。
    bloc.keyword.listen((text) {
      keywordController.value = keywordController.value.copyWith(text: text);
    }).addTo(compositeSubscription);

    //  エラーを購読する。
    bloc.error.listen((error) {
      _showErrorSnackBar(error);
    }).addTo(compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    const constraints = BoxConstraints(maxWidth: 800);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: constraints,
          child: _buildBody(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    keywordController.dispose();
    compositeSubscription.dispose();
    super.dispose();
  }

  //  アプリバーを生成する。
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          FlutterLogo(),
          SizedBox(width: 4),
          Text('Flutter Qiita Clinet'),
        ],
      ),
      centerTitle: true,
    );
  }

  //  ボディ部分を生成する。
  Widget _buildBody() {
    return Column(
      children: [
        //  キーワード入力フィールド
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildKeywordField(),
        ),
        Expanded(
          child: StreamBuilder<bool>(
            initialData: true,
            stream: bloc.isLoading,
            builder: (context, snapshot) {
              final isLoading = snapshot.requireData;

              return StreamBuilder<List<Article>?>(
                initialData: null,
                stream: bloc.articleList,
                builder: (context, snapshot) {
                  final articles = snapshot.data;

                  //  読み込み中の場合
                  if (isLoading) return _loadingIndicator;

                  //  メインコンテンツ部分をリフレッシュ可能にする。
                  return RefreshIndicator(
                    onRefresh: () async {
                      await bloc.refresh();
                    },
                    child: _buildList(articles),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  //  キーワード入力フィールドを生成する。
  Widget _buildKeywordField() {
    return Row(
      children: [
        //  入力フィールド
        Expanded(
          child: TextField(
            controller: keywordController,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(hintText: '検索キーワード'),
            onChanged: (text) => bloc.keywordSink.add(text),
            onEditingComplete: () async {
              await bloc.search();
            },
          ),
        ),
        const SizedBox(width: 8),

        //  検索ボタン
        ElevatedButton(
          onPressed: () async {
            await bloc.search();
          },
          child: const Text('検索'),
        ),
      ],
    );
  }

  //  検索結果のリスト部分を生成する。
  Widget _buildList(List<Article>? articles) {
    //  エラー発生時
    if (articles == null) return const _ErrorMessage();

    //  リストが空の場合
    if (articles.isEmpty) return const _EmptyMessage();

    return ListView.separated(
      itemCount: articles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final article = articles[index];

        return ArticleView(
          article: article,
          onCardTap: _onCardTap,
          onTagTap: _onTagTap,
        );
      },
    );
  }

  //  エラー用SnackBarを表示する。
  void _showErrorSnackBar(ErrorType error) {
    final snackBar = SnackBar(content: Text(error.message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //  Cardがタップされたとき。
  Future<void> _onCardTap(Article article) async {
    await launch(article.url);
  }

  //  タグがタップされたとき。
  Future<void> _onTagTap(String tag) async {
    final encoded = Uri.encodeQueryComponent(tag);
    final url = 'https://qiita.com/tags/$encoded';

    await launch(url);
  }
}

//  ErrorTypeの拡張
extension ErrorTypeEx on ErrorType {
  //  エラーメッセージ
  static const _messages = {
    ErrorType.clientError: '記事の取得に失敗しました。\nネットワーク環境を確認してください。',
    ErrorType.serverError: '記事の取得に失敗しました。\nしばらくして再試行してください。',
  };

  //  エラーメッセージを取得する。
  String get message => _messages[this]!;
}

//  エラーメッセージ
class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 64),
        Icon(Icons.warning, size: 32),
        SizedBox(height: 8),
        Text('エラーが発生しました。', textAlign: TextAlign.center),
      ],
    );
  }
}

//  空メッセージ
class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 64),
        Icon(Icons.warning, size: 32),
        SizedBox(height: 8),
        Text('該当記事が見つかりませんでした。', textAlign: TextAlign.center),
      ],
    );
  }
}

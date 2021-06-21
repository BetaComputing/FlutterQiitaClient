import 'package:flutter/material.dart';
import 'package:flutter_qiita_client/dependency.dart';
import 'package:flutter_qiita_client/search/article_list.dart';
import 'package:flutter_qiita_client/search/search_page_bloc.dart';
import 'package:provider/provider.dart';

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

//  検索ページの実装
class _SearchPage extends StatelessWidget {
  const _SearchPage(this.bloc);

  final SearchPageBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  //  アプリバーを生成する。
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          FlutterLogo(),
          Text('Flutter Qiita Clinet'),
        ],
      ),
      centerTitle: true,
    );
  }

  //  ボディ部分を生成する。
  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _buildTextField(bloc),
              _buildSearchButton(bloc),
            ],
          ),
        ),
        _buildProgressIndicator(bloc),
        Expanded(child: ArticleList(articleListStream: bloc.articleList)),
      ],
    );
  }

  //  テキストフィールドを生成する。
  Widget _buildTextField(SearchPageBloc bloc) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 4.0),
        child: TextFormField(onChanged: bloc.keywordSink.add),
      ),
    );
  }

  //  検索ボタンを生成する。
  Widget _buildSearchButton(SearchPageBloc bloc) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 8.0),
      child: StreamBuilder<bool>(
        initialData: false,
        stream: bloc.isSearchButtonEnabled,
        builder: (context, snapshot) {
          final isEnabled = snapshot.requireData;
          final callback = isEnabled ? () => bloc.searchEvent.add(null) : null;

          return MaterialButton(
            child: const Text('検索'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: callback,
          );
        },
      ),
    );
  }

  //  プログレスインジケータを生成する。
  Widget _buildProgressIndicator(SearchPageBloc bloc) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: bloc.isFetching,
      builder: (context, snapshot) {
        final isFetching = snapshot.requireData;

        return isFetching ? const LinearProgressIndicator() : Container();
      },
    );
  }
}

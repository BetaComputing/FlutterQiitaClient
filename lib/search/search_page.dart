import 'package:flutter/material.dart';
import 'package:flutter_qiita_client/dependency.dart';
import 'package:flutter_qiita_client/search/article_list.dart';
import 'package:flutter_qiita_client/search/search_page_bloc.dart';
import 'package:provider/provider.dart';

//  検索ページ
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Provider<SearchPageBloc>(
        create: (context) => SearchPageBloc(Dependency.resolve()),
        dispose: (context, bloc) => bloc.dispose(),
        child: _SearchPageContent(),
      );
}

//  検索ページのコンテンツ
class _SearchPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchPageBloc>(context);

    return Scaffold(
      appBar: this._buildAppBar(),
      body: this._buildBody(bloc),
    );
  }

  //  アプリバーを構築する。
  PreferredSizeWidget _buildAppBar() => AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FlutterLogo(),
            Text('Flutter Qiita Clinet'),
          ],
        ),
      );

  //  ボディ部分を構築する。
  Widget _buildBody(SearchPageBloc bloc) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                this._buildTextField(bloc),
                this._buildSearchButton(bloc),
              ],
            ),
          ),
          this._buildProgressIndicator(bloc),
          ArticleList(),
        ],
      );

  //  テキストフィールドを構築する。
  Widget _buildTextField(SearchPageBloc bloc) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
          child: TextFormField(onChanged: bloc.keywordSink.add),
        ),
      );

  //  検索ボタンを構築する。
  Widget _buildSearchButton(SearchPageBloc bloc) => Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 8.0),
        child: StreamBuilder<bool>(
          initialData: false,
          stream: bloc.isSearchButtonEnabled,
          builder: (context, snapshot) {
            final isEnabled = snapshot.requireData;
            final callback =
                isEnabled ? () => bloc.searchEvent.add(null) : null;

            return MaterialButton(
              child: const Text('検索'),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: callback,
            );
          },
        ),
      );

  //  プログレスインジケータを構築する。
  Widget _buildProgressIndicator(SearchPageBloc bloc) => StreamBuilder<bool>(
        initialData: false,
        stream: bloc.isFetching,
        builder: (context, snapshot) {
          final isFetching = snapshot.requireData;

          return isFetching ? const LinearProgressIndicator() : Container();
        },
      );
}

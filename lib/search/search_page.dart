import 'package:flutter/material.dart';
import 'package:flutter_qiita_client/search/article_list.dart';

//  検索ページ
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SearchPageContent();
}

//  検索ページのコンテンツ
class _SearchPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this._buildAppBar(),
      body: this._buildBody(),
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
  Widget _buildBody() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                this._buildTextField(),
                this._buildSearchButton(),
              ],
            ),
          ),
          this._buildProgressIndicator(),
          ArticleList(),
        ],
      );

  //  テキストフィールドを構築する。
  Widget _buildTextField() => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
          child: TextFormField(),
        ),
      );

  //  検索ボタンを構築する。
  Widget _buildSearchButton() => Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 8.0),
        child: MaterialButton(
          child: const Text('検索'),
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () {},
        ),
      );

  //  プログレスインジケータを構築する。
  Widget _buildProgressIndicator() => const LinearProgressIndicator();
}

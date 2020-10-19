import 'package:flutter/material.dart';
import 'package:flutter_qiita_client/article/dummy_article.dart';
import 'package:flutter_qiita_client/search/article_view.dart';

class ArticleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Expanded(child: this._buildListView());

  //  ListViewを構築する。
  Widget _buildListView() => ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) => const ArticleView(DummyArticle()),
      );
}

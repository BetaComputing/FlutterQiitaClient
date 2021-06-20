import 'package:flutter/material.dart';
import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/search/article_view.dart';
import 'package:flutter_qiita_client/search/search_page_bloc.dart';
import 'package:provider/provider.dart';

class ArticleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchPageBloc>(context);

    return Expanded(child: this._buildListView(bloc));
  }

  //  ListViewを構築する。
  Widget _buildListView(SearchPageBloc bloc) => StreamBuilder<List<Article>>(
        initialData: const [],
        stream: bloc.articleList,
        builder: (context, snapshot) {
          final list = snapshot.requireData;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => ArticleView(list[index]),
          );
        },
      );
}

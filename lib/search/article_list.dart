import 'package:flutter/material.dart';
import 'package:flutter_qiita_client/article/article.dart';
import 'package:flutter_qiita_client/search/article_view.dart';
import 'package:url_launcher/url_launcher.dart';

/// 記事リスト
class ArticleList extends StatelessWidget {
  const ArticleList({
    Key? key,
    required this.articleListStream,
  }) : super(key: key);

  final Stream<List<Article>> articleListStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Article>>(
      initialData: const [],
      stream: articleListStream,
      builder: (context, snapshot) {
        final list = snapshot.requireData;

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ArticleView(
              article: list[index],
              onCardTap: _onCardTap,
              onTagTap: _onTagTap,
            );
          },
        );
      },
    );
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

import 'package:flutter/material.dart';
import 'package:flutter_qiita_client/article/article.dart';
import 'package:intl/intl.dart';

class ArticleView extends StatelessWidget {
  const ArticleView(Article article) : this._article = article;
  final Article _article;
  static final _formatter = DateFormat('yyyy/MM/dd HH:mm:ss');

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: this._buildContent(),
          ),
          onTap: this._onCardTap,
        ),
      );

  //  コンテンツを構築する。
  Widget _buildContent() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          this._buildIcon(),
          Flexible(
            child: Column(
              children: [
                this._buildTitle(),
                this._buildTags(),
                this._buildFooter(),
              ],
            ),
          ),
        ],
      );

  //  ユーザアイコンを構築する。
  Widget _buildIcon() => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Image.network(
          this._article.authorIconUrl,
          width: 32.0,
          height: 32.0,
        ),
      );

  //  記事タイトルを構築する。
  Widget _buildTitle() => Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 4.0),
        child: Text(
          this._article.title,
          style: const TextStyle(fontSize: 16.0),
        ),
      );

  //  タグリストを構築する。
  Widget _buildTags() => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Wrap(children: this._article.tags.map(this._buildTag).toList()),
      );

  //  フッタ (いいねと作成日時) を構築する。
  Widget _buildFooter() => Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'x ${this._article.likes}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: Text(
                _formatter.format(this._article.createdAt),
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      );

  //  タグを構築する。
  Widget _buildTag(String tag) => InkWell(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 230, 230, 230),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
              child: Text(tag),
            ),
          ),
        ),
        onTap: () => this._onTagTap(tag),
      );

  //  Cardがタップされたとき。
  Future<void> _onCardTap() async {
    // TODO(Someone): Qiita記事への遷移を実装する。
  }

  //  タグがタップされたとき。
  Future<void> _onTagTap(String tag) async {
    // TODO(Someone): タグ検索のページへの遷移を実装する。
  }
}

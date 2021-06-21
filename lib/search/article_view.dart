import 'package:flutter/material.dart';
import 'package:flutter_qiita_client/article/article.dart';
import 'package:intl/intl.dart';

/// 記事のカードがタップされたときのコールバック
typedef OnCardTap = void Function(Article article);

/// 記事のタグがタップされたときのコールバック
typedef OnTagTap = void Function(String tag);

/// 個別の記事のView
class ArticleView extends StatelessWidget {
  const ArticleView({
    Key? key,
    required this.article,
    required this.onCardTap,
    required this.onTagTap,
  }) : super(key: key);

  //  記事の作成日時のフォーマッタ
  static final _formatter = DateFormat('yyyy/MM/dd HH:mm:ss');

  /// 表示対象の記事データ
  final Article article;

  /// 記事のカードがタップされたときのコールバック
  final OnCardTap onCardTap;

  /// 記事のタグがタップされたときのコールバック
  final OnTagTap onTagTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildContent(),
        ),
        onTap: () => onCardTap(article),
      ),
    );
  }

  //  コンテンツを生成する。
  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIcon(),
        Flexible(
          child: Column(
            children: [
              _buildTitle(),
              _buildTags(),
              _buildFooter(),
            ],
          ),
        ),
      ],
    );
  }

  //  ユーザアイコンを生成する。
  Widget _buildIcon() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Image.network(article.authorIconUrl, width: 32.0, height: 32.0),
    );
  }

  //  記事タイトルを生成する。
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 4.0),
      child: Text(article.title, style: const TextStyle(fontSize: 16.0)),
    );
  }

  //  タグリストを生成する。
  Widget _buildTags() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          children: article.tags.map(_buildTag).toList(),
        ),
      ),
    );
  }

  //  フッタ (いいねと作成日時) を生成する。
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          //  いいね
          const Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Icon(Icons.favorite, color: Colors.pink, size: 18),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              'x ${article.likes}',
              style: const TextStyle(fontSize: 16),
            ),
          ),

          //  作成日時
          Expanded(
            child: Text(
              _formatter.format(article.createdAt),
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  //  タグを生成する。
  Widget _buildTag(String tag) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Text(tag),
          ),
        ),
      ),
      onTap: () => onTagTap(tag),
    );
  }
}

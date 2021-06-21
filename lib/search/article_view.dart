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

  //  このWidgetのBoarder
  static final _border = BorderRadius.circular(8);

  //  記事タグのBoarder
  static final _tagBorder = BorderRadius.circular(4);

  /// 表示対象の記事データ
  final Article article;

  /// 記事のカードがタップされたときのコールバック
  final OnCardTap onCardTap;

  /// 記事のタグがタップされたときのコールバック
  final OnTagTap onTagTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: _border),
      child: InkWell(
        onTap: () => onCardTap(article),
        borderRadius: _border,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildContent(),
        ),
      ),
    );
  }

  //  コンテンツを生成する。
  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  アイコン
        _buildIcon(),

        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  記事タイトル
              _buildTitle(),

              //  記事タグ
              _buildTags(),

              //  フッタ
              _buildFooter(),
            ],
          ),
        ),
      ],
    );
  }

  //  ユーザアイコンを生成する。
  Widget _buildIcon() {
    const size = 32.0;

    return Image.network(
      article.authorIconUrl,
      width: size,
      height: size,
      errorBuilder: (context, error, stack) => Container(
        width: size,
        height: size,
        color: Colors.grey,
      ),
    );
  }

  //  記事タイトルを生成する。
  Widget _buildTitle() {
    return Text(
      article.title,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 16),
    );
  }

  //  タグリストを生成する。
  Widget _buildTags() {
    final tags = article.tags.map(_buildTag).toList();

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Wrap(children: tags),
      ),
    );
  }

  //  フッタ (いいねと作成日時) を生成する。
  Widget _buildFooter() {
    return Row(
      children: [
        //  いいねアイコン
        const Icon(Icons.favorite, color: Colors.pinkAccent, size: 18),
        const SizedBox(width: 4),

        //  いいね数
        Text('x ${article.likes}'),

        //  作成日時
        Expanded(
          child: Text(
            _formatter.format(article.createdAt),
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  //  タグを生成する。
  Widget _buildTag(String tag) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: _tagBorder,
        color: const Color.fromARGB(255, 230, 230, 230),
      ),
      child: Material(
        child: InkWell(
          onTap: () => onTagTap(tag),
          borderRadius: _tagBorder,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(tag, style: const TextStyle(fontSize: 12)),
          ),
        ),
      ),
    );
  }
}

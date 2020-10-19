import 'dart:convert';
import 'dart:io';
import 'package:flutter_qiita_client/article/article.dart';
import 'package:test/test.dart';

void main() {
  test('ArticleのJSONパースのテスト', () async {
    //  Qiitaの検索APIは配列で返してくるため、
    //  今回のテストで使う、その中身の先頭要素のオブジェクトを取り出す。
    final jsonStr = await readTestResponseJson();
    final jsonList = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
    final jsonElement = jsonList.first;

    final article = Article.fromJson(jsonElement);

    expect(article.id, equals('cf9a7627c41bf7c13c80'));
    expect(
      article.url,
      equals('https://qiita.com/aridai/items/cf9a7627c41bf7c13c80'),
    );
    expect(
      article.title,
      equals('【Android】プログラム的にBluetoothのペアリングを行う方法【Bluetooth】'),
    );
    expect(article.authorId, equals('aridai'));
    expect(
      article.authorIconUrl,
      equals(
        'https://s3-ap-northeast-1.amazonaws.com/qiita-image-store/0/341119/d45dcff0ceabdf78fa082d872fea08492157dbef/large.png?1581068618',
      ),
    );
    expect(
      article.createdAt.millisecondsSinceEpoch,
      equals(
        DateTime.parse('2020-02-01T08:27:34+09:00').millisecondsSinceEpoch,
      ),
    );
    expect(article.tags, equals(['Android', 'bluetooth']));
    expect(article.likes, equals(0));
  });
}

//  テスト用のJSONを読み込む。
//  (assetsとしてではなく、ローカル実行用リソースとして。)
Future<String> readTestResponseJson() async {
  //  テストをAndroid Studioから実行したときとターミナルから実行したときで、
  //  ファイルの相対配置が異なるみたい。
  //  ダメだったらもう1つの候補を読み取るみたいな方法を取ることにした。
  final candidates = ['./test_response.json', 'test/test_response.json'];

  for (final path in candidates) {
    try {
      final jsonStr = await File(path).readAsString();
      return jsonStr;
    } on Exception {
      continue;
    }
  }

  fail('テスト用JSONファイルが存在しません。');
}

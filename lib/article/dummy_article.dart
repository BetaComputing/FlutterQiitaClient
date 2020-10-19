import 'package:flutter_qiita_client/article/article.dart';

class DummyArticle implements Article {
  const DummyArticle();

  @override
  String get id => 'cf9a7627c41bf7c13c80';

  @override
  String get url => 'https://qiita.com/aridai/items/cf9a7627c41bf7c13c80';

  @override
  String get title => '【Android】プログラム的にBluetoothのペアリングを行う方法【Bluetooth】';

  @override
  String get authorId => 'aridai';

  @override
  String get authorIconUrl =>
      'https://s3-ap-northeast-1.amazonaws.com/qiita-image-store/0/341119/d45dcff0ceabdf78fa082d872fea08492157dbef/large.png?1581068618';

  @override
  DateTime get createdAt => DateTime.now();

  @override
  List<String> get tags => ['Android', 'Bluetooth'];

  @override
  int get likes => 0;
}

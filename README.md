# FlutterQiitaClient

https://github.com/BetaComputing/FlutterQiitaClient

![image](image.gif)

![CI](https://github.com/aridai/FlutterQiitaApp/workflows/CI/badge.svg)
![Dart](https://img.shields.io/static/v1?label=language&message=Dart&color=00B4AB)
![Flutter](https://img.shields.io/static/v1?label=framework&message=Flutter&color=46CAF9)

## 使用ライブラリ

* flutter_dotenv
  * https://pub.dev/packages/flutter_dotenv
  * https://github.com/java-james/flutter_dotenv
* get_it
  * https://pub.dev/packages/get_it
  * https://github.com/fluttercommunity/get_it
* provider
  * https://pub.dev/packages/provider
  * https://github.com/rrousselGit/provider
* RxDart
  * https://pub.dev/packages/rxdart
  * https://github.com/ReactiveX/rxdart
* Intl
  * https://github.com/flutter/plugins/tree/master/packages/url_launcher
  * https://github.com/dart-lang/intl
* url_launcher
  * https://pub.dev/packages/url_launcher
  * https://github.com/flutter/plugins/tree/master/packages/url_launcher

## 環境変数

プロジェクトルートに `.env` を配置してください。

```
QIITA_BEARER_TOKEN=ここにQiitaのトークンを記述

```

## 開発用コマンド

### ビルド (Android)

```
flutter build apk --debug
```

### ビルド (iOS)

```
flutter build ios --debug
```

### テスト

```
flutter test
```

### フォーマッタ

```
dart format --fix ./
```

### 静的解析

```
flutter analyze
```

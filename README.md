# FlutterQiitaClient

https://github.com/BetaComputing/FlutterQiitaClient

![image](image.gif)

![CI](https://github.com/aridai/FlutterQiitaApp/workflows/CI/badge.svg)
![Dart](https://img.shields.io/static/v1?label=language&message=Dart&color=00B4AB)
![Flutter](https://img.shields.io/static/v1?label=framework&message=Flutter&color=46CAF9)

## 使用ライブラリ

[一覧](LIBRARIES.md)

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

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_qiita_client/article/article_query_service.dart';
import 'package:flutter_qiita_client/article/article_query_service_impl.dart';
import 'package:get_it/get_it.dart';

class Dependency {
  static void setup() {
    GetIt.I.registerSingleton<String>(
      dotenv.env['QIITA_BEARER_TOKEN']!,
      instanceName: 'QIITA_BEARER_TOKEN',
    );
    GetIt.I.registerLazySingleton<ArticleQueryService>(
      () => ArticleQueryServiceImpl(
        Dependency.resolve(name: 'QIITA_BEARER_TOKEN'),
      ),
    );
  }

  static T resolve<T extends Object>({String? name}) =>
      GetIt.I.get<T>(instanceName: name);
}

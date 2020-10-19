import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_qiita_client/article/article_repository.dart';
import 'package:flutter_qiita_client/article/article_repository_impl.dart';
import 'package:get_it/get_it.dart';

class Dependency {
  static void setup() {
    GetIt.I.registerSingleton<String>(
      DotEnv().env['QIITA_BEARER_TOKEN'],
      instanceName: 'QIITA_BEARER_TOKEN',
    );
    GetIt.I.registerLazySingleton<ArticleRepository>(
      () => ArticleRepositoryImpl(
        Dependency.resolve(name: 'QIITA_BEARER_TOKEN'),
      ),
    );
  }

  static T resolve<T>({String name}) => GetIt.I.get(instanceName: name);
}

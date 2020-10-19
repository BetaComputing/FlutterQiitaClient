import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

class Dependency {
  static void setup() {
    GetIt.I.registerSingleton<String>(
      DotEnv().env['QIITA_BEARER_TOKEN'],
      instanceName: 'QIITA_BEARER_TOKEN',
    );
  }

  static T resolve<T>({String name}) => GetIt.I.get(instanceName: name);
}

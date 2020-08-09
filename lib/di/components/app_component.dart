import 'package:heady/data/repository.dart';
import 'package:heady/di/modules/netwok_module.dart';
import 'package:heady/main.dart';
import 'package:inject/inject.dart';

import 'app_component.inject.dart' as g;

/// The top level injector that stitches together multiple app features into
/// a complete app.
@Injector(const [NetworkModule])
abstract class AppComponent {
  @provide
  MyApp get app;

  static Future<AppComponent> create(
    NetworkModule networkModule,
  ) async {
    return await g.AppComponent$Injector.create(
      networkModule,
    );
  }

  /// An accessor to RestClient object that an application may use.
  @provide
  Repository getRepository();
}

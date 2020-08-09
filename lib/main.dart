import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heady/constants/app_theme.dart';
import 'package:heady/di/components/app_component.dart';
import 'package:heady/di/modules/netwok_module.dart';
import 'package:heady/stores/data_store.dart';
import 'package:heady/ui/home/home_page.dart';
import 'package:inject/inject.dart';
import 'package:provider/provider.dart';

// global instance for app component
AppComponent appComponent;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    appComponent = await AppComponent.create(
      NetworkModule(),
    );
    runApp(appComponent.app);
  });
}

@provide
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final DataStore _dataStore = DataStore(appComponent.getRepository());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DataStore>(create: (_) => _dataStore),
      ],
      child: MaterialApp(
        title: 'Heady',
        theme: themeData,
        home: MyHomePage(),
      ),
    );
  }
}

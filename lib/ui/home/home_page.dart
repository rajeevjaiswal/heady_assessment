import 'package:flutter/material.dart';
import 'package:heady/stores/data_store.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataStore _dataStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Heady"),
      ),
      body: Container(
        color: Colors.red,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _dataStore = Provider.of<DataStore>(context);

    _dataStore.getData();
  }
}

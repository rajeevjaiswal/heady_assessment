import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:heady/constants/app_style.dart';
import 'package:heady/data/local/entity/Category.dart';
import 'package:heady/stores/data_store.dart';
import 'package:heady/ui/home/child_category_page.dart';
import 'package:heady/ui/home/product_page.dart';
import 'package:heady/utils/next_screen.dart';
import 'package:heady/widgets/category_list_widget.dart';
import 'package:heady/widgets/category_widget.dart';
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
        title: Text(
          "Heady",
          style: childTextStyle,
        ),
      ),
      body: _buildBody(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _dataStore = Provider.of<DataStore>(context);
    if (!_dataStore.loading) {
      _dataStore.getData();
    }
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _dataStore.loading
            ? Center(child: CircularProgressIndicator())
            : _buildListView();
      },
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_dataStore.errorStore.errorMessage.isNotEmpty) {
          return Column(
            children: <Widget>[
              Text(
                _dataStore.errorStore.errorMessage,
              ),
              SizedBox(
                height: 32,
              ),
              FlatButton.icon(
                onPressed: () => _dataStore.getData(),
                icon: Icon(
                  Icons.cloud_off,
                ),
                label: Text(
                  "Retry",
                ),
              )
            ],
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  Widget _buildListView() {
    return _dataStore.parentCategoryList != null
        ? ListView.builder(
            itemCount: _dataStore.parentCategoryList.length,
            itemBuilder: (context, position) {
              var catData = _dataStore.parentCategoryList[position];
              return CategoryListWidget(
                data: catData,
                onCategorySelected: _handleTap,
              );
            })
        : Container(
            child: Center(child: Text("Unable to load data")),
          );
  }

  void _handleTap(Category childData) {
    if (childData.subCategoryCount > 0) {
      nextScreen(
          context, ChildCategoryPage(title: childData.name, id: childData.id));
    }

    if (childData.productCount > 0) {
      nextScreen(context,
          ProductPage(title: childData.name, categoryId: childData.id));
    }
  }
}

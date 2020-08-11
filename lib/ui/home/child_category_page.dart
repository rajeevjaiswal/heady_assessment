import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:heady/constants/app_style.dart';
import 'package:heady/data/local/entity/Category.dart';
import 'package:heady/stores/data_store.dart';
import 'package:heady/ui/home/product_page.dart';
import 'package:heady/utils/next_screen.dart';
import 'package:heady/widgets/category_list_widget.dart';
import 'package:heady/widgets/category_widget.dart';
import 'package:provider/provider.dart';

class ChildCategoryPage extends StatefulWidget {
  final String title;
  final int id;

  ChildCategoryPage({@required this.title, @required this.id});

  @override
  _ChildCategoryPageState createState() => _ChildCategoryPageState();
}

class _ChildCategoryPageState extends State<ChildCategoryPage> {
  DataStore _dataStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? "",
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
    if (!_dataStore.childLoading) {
      _dataStore.getChildCategories(widget.id);
    }
  }

  Widget _buildBody() {
    return Observer(
      builder: (context) {
        return _dataStore.childLoading
            ? Center(child: CircularProgressIndicator())
            : _buildListView();
      },
    );
  }

  Widget _buildListView() {
    return _dataStore.childCategoryList != null
        ? ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _dataStore.childCategoryList?.length,
            itemBuilder: (context, position) {
              var catData = _dataStore.childCategoryList[position];

              /// if still there are child categories then show both else show single
              return catData.hasChildCategories
                  ? CategoryListWidget(
                      onCategorySelected: _handleTap,
                      data: catData,
                    )
                  : InkWell(
                      onTap: () => _handleTap(catData.category),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        height: 120,
                        child: CategoryWidget(name: catData.category.name),
                      ),
                    );
            })
        : Container();
  }

  void _handleTap(Category childData) {
    if (childData.subCategoryCount > 0) {
      nextScreen(
          context, ChildCategoryPage(title: childData.name, id: childData.id));
    }

    print("actual product count ${childData.productCount}");

    if (childData.productCount > 0) {
      nextScreen(context,
          ProductPage(title: childData.name, categoryId: childData.id));
    }
  }
}

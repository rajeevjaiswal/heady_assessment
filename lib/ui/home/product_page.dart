import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:heady/constants/app_style.dart';
import 'package:heady/data/local/entity/product.dart';
import 'package:heady/stores/data_store.dart';
import 'package:heady/widgets/category_widget.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final String title;
  final int categoryId;

  ProductPage({@required this.title, @required this.categoryId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
      body: Builder(
        // builder is used only for the snackbar, if you don't want the snackbar you can remove
        // Builder from the tree
        builder: (BuildContext context) => HawkFabMenu(
          icon: AnimatedIcons.menu_close,
          fabColor: Colors.yellow,
          iconColor: Colors.green,
          items: [
            HawkFabMenuItem(
                label: 'Most Viewed',
                ontap: () {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Sorting by most viewed')),
                  );
                },
                icon: Icon(Icons.pageview),
                labelColor: Colors.green,
                labelBackgroundColor: Colors.yellow),
            HawkFabMenuItem(
                label: 'Most Ordered',
                ontap: () {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Sorting by most ordered')),
                  );
                },
                icon: Icon(Icons.shopping_cart),
                labelColor: Colors.green,
                labelBackgroundColor: Colors.yellow),
            HawkFabMenuItem(
                label: 'Most Shared',
                ontap: () {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Sorting by most shared')),
                  );
                },
                icon: Icon(Icons.share),
                labelColor: Colors.green,
                labelBackgroundColor: Colors.yellow),
          ],
          body: _buildBody(),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _dataStore = Provider.of<DataStore>(context);
    if (!_dataStore.productLoading) {
      _dataStore.getProductsByCategoryId(widget.categoryId);
    }
  }

  Widget _buildBody() {
    return Observer(
      builder: (context) {
        return _dataStore.productLoading
            ? CircularProgressIndicator()
            : _buildListView();
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dataStore.productList.length,
        itemBuilder: (context, position) {
          var productData = _dataStore.productList[position];
          return InkWell(
            onTap: () => _handleTap(productData),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 120,
              child: CategoryWidget(name: productData.name),
            ),
          );
        });
  }

  void _handleTap(Product product) {}
}

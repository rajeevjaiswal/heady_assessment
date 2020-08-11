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
  int _sortId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? "",
          style: titleTextStyle,
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
                  _sortId = 0;
                  _dataStore.getProductsByCategoryId(
                      widget.categoryId, _sortId);
                },
                icon: Icon(Icons.pageview),
                labelColor: Colors.green,
                labelBackgroundColor: Colors.white),
            HawkFabMenuItem(
                label: 'Most Ordered',
                ontap: () {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Sorting by most ordered')),
                  );
                  _sortId = 1;
                  _dataStore.getProductsByCategoryId(
                      widget.categoryId, _sortId);
                },
                icon: Icon(Icons.shopping_cart),
                labelColor: Colors.green,
                labelBackgroundColor: Colors.white),
            HawkFabMenuItem(
                label: 'Most Shared',
                ontap: () {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Sorting by most shared')),
                  );
                  _sortId = 2;
                  _dataStore.getProductsByCategoryId(
                      widget.categoryId, _sortId);
                },
                icon: Icon(Icons.share),
                labelColor: Colors.green,
                labelBackgroundColor: Colors.white),
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
      _dataStore.getProductsByCategoryId(widget.categoryId, _sortId);
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
              child: Stack(children: [
                CategoryWidget(
                  name: productData.name,
                  width: double.infinity,
                ),
                _sortId != null
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.red,
                        child: Text(
                          showTextLabel(productData),
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
              ]),
            ),
          );
        });
  }

  String showTextLabel(Product productData) {
    var text = '';
    if (_sortId == 0) {
      text = "Views : ${productData.viewCount.toString()}";
    } else if (_sortId == 1) {
      text = "Orders : ${productData.orderCount.toString()}";
    } else if (_sortId == 2) {
      text = "Shares : ${productData.shareCount.toString()}";
    }
    return text;
  }

  void _handleTap(Product product) async {
    var details = await _dataStore.getProductDetails(product.id);

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(
                "${product.name} details",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (details.variants != null) ...[
                    Text(
                      "Variants :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: details.variants
                          .map((variant) => Text(
                              "Color : ${variant.color ?? "NA"} , Size : ${variant.size ?? "NA"} , Price : ${variant.price ?? "NA"}"))
                          .toList(),
                    )
                  ],
                  SizedBox(
                    height: 16,
                  ),
                  Text("${details.vat.name} : ${details.vat.value}"),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Views : ${product.viewCount.toString()}"),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Orders : ${product.orderCount.toString()}"),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Shares : ${product.shareCount.toString()}"),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}

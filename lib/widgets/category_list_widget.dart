import 'package:flutter/material.dart';
import 'package:heady/constants/app_style.dart';
import 'package:heady/data/local/entity/Category.dart';
import 'package:heady/models/category_with_children.dart';
import 'package:heady/widgets/category_widget.dart';

class CategoryListWidget extends StatelessWidget {
  final CategoryWithChildren data;
  final Function(Category) onCategorySelected;

  CategoryListWidget({
    @required this.data,
    @required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            data.category.name,
            style: catTextStyle,
          ),
        ),
        Container(
          height: 80,
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.childCategories.length,
              itemBuilder: (context, childPosition) {
                var childData = data.childCategories[childPosition];
                return InkWell(
                    onTap: () => onCategorySelected(childData),
                    child: CategoryWidget(name: childData.name));
              }),
        )
      ],
    );
  }
}

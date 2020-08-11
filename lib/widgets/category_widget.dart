import 'package:flutter/material.dart';
import 'package:heady/constants/app_style.dart';

class CategoryWidget extends StatelessWidget {
  final String name;
  final double width;
  CategoryWidget({@required this.name, this.width = 140});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      width: width,
      child: Center(
          child: Text(
        name,
        style: childTextStyle,
      )),
    );
  }
}

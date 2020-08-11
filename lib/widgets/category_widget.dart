import 'package:flutter/material.dart';
import 'package:heady/constants/app_style.dart';

class CategoryWidget extends StatelessWidget {
  final String name;
  CategoryWidget({@required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      width: 140,
      child: Center(
          child: Text(
        name,
        style: childTextStyle,
      )),
    );
  }
}

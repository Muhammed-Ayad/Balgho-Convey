import 'package:flutter/material.dart';

PreferredSizeWidget appBarWidget(String title,double elevation,BuildContext context) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    elevation: elevation,
    title:  Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 25,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}

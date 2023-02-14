import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:great_quran/theme/dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.elevation = D.sizeXXSmall,
    this.actions,
  }) : super(key: key);
  final String title;
  final double elevation;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    log("App bar $title");
    return AppBar(
      elevation: elevation,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 25,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

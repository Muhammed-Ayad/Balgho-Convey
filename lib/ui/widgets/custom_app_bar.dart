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
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      elevation: elevation,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 25,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

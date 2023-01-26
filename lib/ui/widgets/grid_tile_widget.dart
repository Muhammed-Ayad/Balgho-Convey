import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
 
class GridTileWidget extends StatelessWidget {
  const GridTileWidget({
    super.key,
    this.isLast = false,
    required this.child,
  });
  final bool isLast;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: isLast ? 4 : 2,
      mainAxisCellCount: 2,
      child: child,
    );
  }
}

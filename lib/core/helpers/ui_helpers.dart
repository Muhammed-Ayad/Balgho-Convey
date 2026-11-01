import 'package:flutter/widgets.dart';

class UiHelper {
  static void postBuild(void Function(Duration) callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }
}

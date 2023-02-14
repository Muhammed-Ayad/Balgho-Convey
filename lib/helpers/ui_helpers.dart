import 'package:flutter/material.dart';
import 'package:great_quran/helpers/extensions.dart';

import 'package:overlay_support/overlay_support.dart';

import '../theme/dimensions.dart';

// ignore_for_file: avoid_classes_with_only_static_members
///
/// Contains useful functions to reduce boilerplate code
///
class UiHelper {
  //* <--------------------- Notifications State
  static String _notificationMessage = '';

  //* <---------------------------------------------------------  Border Radius

  // Custom Methods
  static BorderRadius allRoundedEdges([double radius = D.defaultRadius]) {
    return BorderRadius.all(Radius.circular(radius));
  }

  static BorderRadius topRoundedEdges([double radius = D.defaultRadius]) {
    return BorderRadius.only(
        topLeft: Radius.circular(radius), topRight: Radius.circular(radius));
  }

  static BorderRadius bottomRoundedEdges([double radius = D.defaultRadius]) {
    return BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius));
  }

  static BorderRadius rightRoundedEdges([double radius = D.defaultRadius]) {
    return BorderRadius.only(
        bottomRight: Radius.circular(radius),
        topRight: Radius.circular(radius));
  }

  static BorderRadius leftRoundedEdges([double radius = D.defaultRadius]) {
    return BorderRadius.only(
        topLeft: Radius.circular(radius), bottomLeft: Radius.circular(radius));
  }

  static BorderRadius topRightRoundedEdge([double radius = D.defaultRadius]) {
    return BorderRadius.only(topRight: Radius.circular(radius));
  }

  static BorderRadius topLeftRoundedEdge([double radius = D.defaultRadius]) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
    );
  }

  static BorderRadius bottomLeftRoundedEdge([double radius = D.defaultRadius]) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
    );
  }

  static BorderRadius bottomRightRoundedEdge(
      [double radius = D.defaultRadius]) {
    return BorderRadius.only(
      bottomRight: Radius.circular(radius),
    );
  }

  //* <-------------------------------------------------- Shadow
  static List<BoxShadow> shadow({
    Color? color,
    double spreadRadius = 1,
    double blurRadius = 3,
    Offset offset = const Offset(0, 2),
  }) =>
      [
        BoxShadow(
          color: color ?? Colors.grey.withOpacity(0.3),
          spreadRadius: spreadRadius,
          blurRadius: blurRadius,
          offset: offset, // changes position of shadow
        ),
      ];

  //* <--------------------------------------------------- Gradient
  static Gradient appGradient(List<Color> gradients, {bool reverse = false}) =>
      LinearGradient(colors: reverse ? gradients.reversed.toList() : gradients);

  //* <------------------------------------------------ Notification & Messages

  static void showQuickNotification(BuildContext context, String message,
      {Widget? trailing}) {
    showSimpleNotification(
      Row(
        children: [
          Expanded(
              child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).primaryColorLight),
          )),
          if (trailing != null)
            SizedBox(
              width: 100,
              child: trailing,
            )
        ],
      ),
      background: Theme.of(context).secondaryHeaderColor,
    );
  }

// Show Notification
  static void showNotification(
    String message, {
    NotificationPosition position = NotificationPosition.top,
    int durationInSeconds = 3,
    bool isError = false,
  }) {
    if (_notificationMessage != message) {
      _notificationMessage = message;
      showOverlayNotification(
        (context) => Container(
          margin: EdgeInsets.symmetric(
              horizontal: 16, vertical: context.heightR(0.15)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.0),
            color: isError ? Colors.red : const Color(0xe5041a35),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4c000000),
                offset: Offset(0, 7),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(D.sizeLarge),
            child: Center(
              child: Text(
                message,
                style:
                    context.textTheme.bodyLarge?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        duration: Duration(seconds: durationInSeconds),
        position: position,
      ).dismissed.then((value) {
        _notificationMessage = '';
      });
    }
  }

  // Show Alert Dialog
  static void showSimpleAlertDialog(
      {required BuildContext context,
      required VoidCallback action,
      required String message,
      required String okButtonText,
      required String cancelButtonText}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(
          message,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              cancelButtonText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextButton(
            onPressed: action,
            child: Text(okButtonText,
                style: Theme.of(context).textTheme.titleSmall),
          ),
        ],
      ),
    );
  }

  //* <----------------------------------------- Functions & Extensions
  // Post Frame Callbacks
  static void postBuild(void Function(Duration) callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }

  Row dottedLine({
    Color color = const Color(0xFFE8E8E8),
    double height = 0.5,
    double width = 5,
  }) {
    return Row(
      children: List.generate(
        400 ~/ width,
        (index) => Expanded(
          child: Container(
            color: index.isEven ? Colors.transparent : color,
            height: height,
          ),
        ),
      ),
    );
  }
}

//  Vertical Dashed Line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 2;
    const double dashSpace = 2;
    double startX = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

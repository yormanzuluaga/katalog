import 'package:flutter/material.dart';

Future<T?> showWebModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = false,
}) {
  return showDialog(
    barrierDismissible: isDismissible,
    context: context,
    builder: builder,
  );
}

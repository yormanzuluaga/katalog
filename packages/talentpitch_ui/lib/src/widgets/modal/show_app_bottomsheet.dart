import 'package:flutter/material.dart';

Future<T?> showAppBottomsheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useSafeArea = false,
}) {
  return showModalBottomSheet(
    context: context,
    builder: builder,
    isScrollControlled: true,
    useSafeArea: useSafeArea,
  );
}

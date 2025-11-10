import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

/// Modal which is styled for the Flutter News Example app.
Future<T?> showAppModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  RouteSettings? routeSettings,
  BoxConstraints? constraints,
  double? elevation,
  Color? barrierColor,
  bool isDismissible = false,
  bool enableDrag = false,
  ShapeBorder? shape,
  AnimationController? transitionAnimationController,
}) {
  return showModalBottomSheet(
    context: context,
    builder: builder,
    shape: shape,
    backgroundColor: AppColors.transparent,
    routeSettings: routeSettings,
    constraints: constraints,
    isScrollControlled: true,
    barrierColor: barrierColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    transitionAnimationController: transitionAnimationController,
    elevation: elevation,
  );
}

Future<void> startLoadingModal(BuildContext context) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
        child: Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(),
    )),
  );
}

Future<void> stopLoadingModal(BuildContext context) async {
  Navigator.of(context).pop();
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

/// Icon Size
double _iconSize(BuildContext context, _TypeCounter typeCounter) {
  switch (typeCounter) {
    case _TypeCounter.normal:
      return 30;
    case _TypeCounter.small:
      return 26;
    case _TypeCounter.form:
      return MediaQuery.of(context).size.width * 0.08;
    case _TypeCounter.light:
      return 27;

    case _TypeCounter.wihtoutDelete:
      return 27;
  }
}

/// Padding of Icon
double _paddingVerticalIcon(BuildContext context, _TypeCounter typeCounter) {
  switch (typeCounter) {
    case _TypeCounter.normal:
      return 8;
    case _TypeCounter.small:
      return 5;
    case _TypeCounter.form:
      return MediaQuery.of(context).size.width * 0.012;
    case _TypeCounter.light:
      return 5;

    case _TypeCounter.wihtoutDelete:
      return 5;
  }
}

/// Padding of Icon
double _paddingHorizontalIcon1(_TypeCounter typeCounter) {
  switch (typeCounter) {
    case _TypeCounter.normal:
      return 12;
    case _TypeCounter.small:
      return 4;
    case _TypeCounter.form:
      return 4;
    case _TypeCounter.light:
      return 4;
    case _TypeCounter.wihtoutDelete:
      return 4;
  }
}

/// Padding of Icon
double _paddingHorizontalIcon2(_TypeCounter typeCounter) {
  switch (typeCounter) {
    case _TypeCounter.normal:
      return 4;
    case _TypeCounter.small:
      return 2;
    case _TypeCounter.form:
      return 2;
    case _TypeCounter.light:
      return 2;
    case _TypeCounter.wihtoutDelete:
      return 2;
  }
}

/// Height of Background Delete Button
double _heightBackDeleteButton(BuildContext context, _TypeCounter typeCounter) {
  switch (typeCounter) {
    case _TypeCounter.normal:
      return 44;
    case _TypeCounter.small:
      return 36;
    case _TypeCounter.form:
      return MediaQuery.of(context).size.width * 0.096;
    case _TypeCounter.light:
      return 36;
    case _TypeCounter.wihtoutDelete:
      return 36;
  }
}

/// Border radius to use in the [APCounter]
double _borderRadius(_TypeCounter typeCounter) {
  switch (typeCounter) {
    case _TypeCounter.normal:
      return 12;
    case _TypeCounter.small:
      return 8;
    case _TypeCounter.form:
      return 8;
    case _TypeCounter.light:
      return 14;

    case _TypeCounter.wihtoutDelete:
      return 14;
  }
}

/// Padding to use in the [APCounter]
double _paddingText(int lenght, _TypeCounter typeCounter) {
  if (lenght == 1) {
    switch (typeCounter) {
      case _TypeCounter.normal:
        return 12;
      case _TypeCounter.small:
        return 10;
      case _TypeCounter.form:
        return 10;
      case _TypeCounter.light:
        return 10;
      case _TypeCounter.wihtoutDelete:
        return 10;
    }
  } else if (lenght == 2) {
    switch (typeCounter) {
      case _TypeCounter.normal:
        return 3.2;
      case _TypeCounter.small:
        return 5;
      case _TypeCounter.form:
        return 5;
      case _TypeCounter.light:
        return 5;
      case _TypeCounter.wihtoutDelete:
        return 5;
    }
  } else {
    return 0;
  }
}

class AppCounters extends StatefulWidget {
  const AppCounters.normal({
    super.key,
    required this.onChange,
    this.onDelete,
    this.labelDelete = 'Delete',
    required this.initialValue,
    this.resetCounterAfterDelete = false,
    this.color = AppColors.secondary,
    this.backgroundColor = AppColors.whiteTechnical,
  }) : _typeCounter = _TypeCounter.normal;

  @Deprecated(
    'Use APCounter.light instead. '
    'This feature will be deprecated after January, 25 of 2023.',
  )
  const AppCounters.small({
    super.key,
    required this.onChange,
    this.onDelete,
    required this.initialValue,
    this.resetCounterAfterDelete = false,
  })  : _typeCounter = _TypeCounter.small,
        labelDelete = 'Delete',
        color = AppColors.secondary,
        backgroundColor = AppColors.whiteTechnical;

  @Deprecated(
    'Use APCounter.withoutDelete instead. '
    'This feature will be deprecated after January, 25 of 2023.',
  )
  const AppCounters.form({
    super.key,
    required this.onChange,
    required this.initialValue,
    this.resetCounterAfterDelete = false,
    this.color = AppColors.secondary,
  })  : _typeCounter = _TypeCounter.form,
        labelDelete = 'Delete',
        onDelete = null,
        backgroundColor = AppColors.whiteTechnical;

  const AppCounters.withoutDelete({
    super.key,
    required this.onChange,
    required this.initialValue,
    this.resetCounterAfterDelete = false,
    this.color = AppColors.secondary,
    this.backgroundColor = AppColors.whiteTechnical,
  })  : _typeCounter = _TypeCounter.wihtoutDelete,
        labelDelete = 'Delete',
        onDelete = null;

  const AppCounters.light({
    super.key,
    required this.onChange,
    this.onDelete,
    required this.initialValue,
    this.resetCounterAfterDelete = false,
    this.color = AppColors.primaryMain,
    this.backgroundColor = AppColors.whiteTechnical,
  })  : _typeCounter = _TypeCounter.light,
        labelDelete = 'Delete';

  /// The type of style. The type of style is [_TypeCounter].
  ///
  /// There are three types of style: normal, small
  final _TypeCounter _typeCounter;

  /// The callback when the value of the counter is changed.
  ///
  /// The default value is 1.
  final void Function(int) onChange;

  /// The callback when the value of the counter is 0.
  ///
  /// The default value is 1.
  final VoidCallback? onDelete;

  /// The value of the Delete Button.
  ///
  /// The default value is 'Delete'.
  final String labelDelete;

  /// The value of the counter.
  ///
  /// The default value is 1.
  final int initialValue;

  /// Set [bool] to true if you want to reset counter to 1.
  ///
  /// The default value is false.
  final bool? resetCounterAfterDelete;

  /// Color of the icons of the counter.
  ///
  /// The default value is [AppColors.secondaryLight].
  final Color color;

  /// Color of the background of the counter.
  ///
  /// The default value is [AppColors.background.secondaryLight].
  final Color backgroundColor;

  @override
  State<AppCounters> createState() => _AppCounterstate();
}

class _AppCounterstate extends State<AppCounters> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<int> animation;

  /// The value of the counter.
  late Counter _counter;

  /// Visible Delete value
  late Boolean _onDelete;

  @override
  void initState() {
    _counter = Counter('name ${widget.key}', 'description ${widget.key}');
    _onDelete = Boolean('name ${widget.key}', 'description ${widget.key}');

    animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    animation = IntTween(begin: 0, end: 185).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut,
      ),
    );
    animation.addListener(() {
      if (mounted) setState(() {});
    });

    if (widget.initialValue != null) {
      _counter.value = widget.initialValue.toDouble();
      if (_counter.value < 1) {
        setState(() {
          _counter.value = 0;
          if (animationController.value == 0.0) {
            animationController.forward();
          } else {
            animationController.reverse();
          }

          _onDelete.value = true;
        });
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      animationController.dispose();
    }
    super.dispose();
  }

  void _onIncrement() {
    if (_counter.value < 999) {
      setState(() {
        _counter.value++;
        if (_onDelete.value == true) {
          _onDelete.value = false;
          if (animationController.value == 0.0) {
            animationController.forward();
          } else {
            animationController.reverse();
          }
        }
        HapticFeedback.lightImpact();
      });
    }
    widget.onChange(_counter.value.toInt());
  }

  void _onDecrement() {
    _counter.value > 1
        ? setState(() {
            _counter.value--;
            HapticFeedback.lightImpact();
            widget.onChange(_counter.value.toInt());
          })
        : setState(() {
            _counter.value = 0;
            if (animationController.value == 0.0) {
              animationController.forward();
            } else {
              animationController.reverse();
            }
            widget.onChange(_counter.value.toInt());
            _onDelete.value = true;
          });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._typeCounter) {
      case _TypeCounter.normal:
        return Stack(
          key: widget.key,
          children: [
            Material(
              color: Colors.transparent,
              child: Ink(
                width: double.infinity,
                height: _heightBackDeleteButton(context, widget._typeCounter),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _borderRadius(widget._typeCounter),
                  ),
                  color: widget.color,
                ),
                child: InkWell(
                  highlightColor: AppColors.whitePure.withOpacity(0.2),
                  splashColor: AppColors.whitePure.withOpacity(0.5),
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _borderRadius(widget._typeCounter),
                    ),
                  ),
                  onTap: () => {widget.onDelete!(), HapticFeedback.lightImpact(), widget.resetCounterAfterDelete == true ? _onIncrement() : null},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.labelDelete,
                        style: APTextStyle.textMD.semibold.copyWith(color: AppColors.whiteTechnical),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(flex: animation.value, child: Container()),
                Expanded(
                  flex: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.whitePure,
                      borderRadius: BorderRadius.circular(
                        _borderRadius(widget._typeCounter),
                      ),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.backgroundColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(
                          _borderRadius(widget._typeCounter),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_onDelete.value == false && animation.value < 5)
                            GestureDetector(
                              onTap: _onDecrement,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: _paddingVerticalIcon(
                                    context,
                                    widget._typeCounter,
                                  ),
                                  horizontal: _paddingHorizontalIcon1(
                                    widget._typeCounter,
                                  ),
                                ),
                                child: _counter.value > 1
                                    ? Icon(
                                        Icons.remove,
                                        color: widget.color,
                                        size: _iconSize(
                                          context,
                                          widget._typeCounter,
                                        ),
                                      )
                                    : Icon(
                                        Icons.delete_outline_outlined,
                                        color: widget.color,
                                        size: _iconSize(
                                          context,
                                          widget._typeCounter,
                                        ),
                                      ),
                              ),
                            )
                          else
                            Container(),
                          if (_onDelete.value == false && animation.value < 5)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: _paddingText(
                                  _counter.value.toInt().toString().length,
                                  widget._typeCounter,
                                ),
                              ),
                              child: AppAnimatedCounter(
                                duration: const Duration(milliseconds: 200),
                                value: _counter.value.toInt(),
                                /* pass in a number like 2014 */
                                textStyle: APTextStyle.displayXS.bold.copyWith(color: widget.color),
                              ),
                            )
                          else
                            Container(),
                          GestureDetector(
                            onTap: _onIncrement,
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                vertical: _paddingVerticalIcon(
                                  context,
                                  widget._typeCounter,
                                ),
                                horizontal: _onDelete.value == false && animation.value < 5
                                    ? _paddingHorizontalIcon1(
                                        widget._typeCounter,
                                      )
                                    : _paddingHorizontalIcon2(
                                        widget._typeCounter,
                                      ),
                              ),
                              child: Icon(
                                Icons.add,
                                color: widget.color,
                                size: _iconSize(context, widget._typeCounter),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );

      case _TypeCounter.small:
        return Stack(
          key: widget.key,
          children: [
            Material(
              color: Colors.transparent,
              child: Ink(
                width: double.infinity,
                height: _heightBackDeleteButton(context, widget._typeCounter),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _borderRadius(widget._typeCounter),
                  ),
                  color: AppColors.primaryMain,
                ),
                child: InkWell(
                  highlightColor: AppColors.whitePure.withOpacity(0.1),
                  splashColor: AppColors.whitePure.withOpacity(0.5),
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _borderRadius(widget._typeCounter),
                    ),
                  ),
                  onTap: () => {widget.onDelete!(), HapticFeedback.lightImpact()},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.delete_outline_outlined,
                        color: AppColors.whiteTechnical,
                        size: _iconSize(context, widget._typeCounter),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(flex: animation.value, child: Container()),
                Expanded(
                  flex: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.whiteTechnical,
                      borderRadius: BorderRadius.circular(
                        _borderRadius(widget._typeCounter),
                      ),
                      border: Border.all(
                        color: AppColors.secondaryDark,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_onDelete.value == false && animation.value < 5)
                          GestureDetector(
                            onTap: _onDecrement,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: _paddingVerticalIcon(
                                  context,
                                  widget._typeCounter,
                                ),
                                horizontal: _paddingHorizontalIcon1(
                                  widget._typeCounter,
                                ),
                              ),
                              child: _counter.value > 1
                                  ? Icon(
                                      Icons.remove,
                                      color: AppColors.secondaryDark,
                                      size: _iconSize(
                                        context,
                                        widget._typeCounter,
                                      ),
                                    )
                                  : Icon(
                                      Icons.delete_outline_outlined,
                                      color: AppColors.primaryMain,
                                      size: _iconSize(
                                        context,
                                        widget._typeCounter,
                                      ),
                                    ),
                            ),
                          )
                        else
                          Container(),
                        if (_onDelete.value == false && animation.value < 5)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: _paddingText(
                                _counter.value.toInt().toString().length,
                                widget._typeCounter,
                              ),
                            ),
                            child: AppAnimatedCounter(
                              duration: const Duration(milliseconds: 200),
                              value: _counter.value.toInt(),
                              textStyle: APTextStyle.textXL.bold,
                            ),
                          )
                        else
                          Container(),
                        GestureDetector(
                          onTap: _onIncrement,
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              vertical: _paddingVerticalIcon(
                                context,
                                widget._typeCounter,
                              ),
                              horizontal: _onDelete.value == false && animation.value < 5
                                  ? _paddingHorizontalIcon1(
                                      widget._typeCounter,
                                    )
                                  : _paddingHorizontalIcon2(
                                      widget._typeCounter,
                                    ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: AppColors.secondaryDark,
                              size: _iconSize(context, widget._typeCounter),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        );

      case _TypeCounter.form:
        return Stack(
          key: widget.key,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: _counter.value > 0 ? _onDecrement : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: _paddingVerticalIcon(
                        context,
                        widget._typeCounter,
                      ),
                      horizontal: _paddingHorizontalIcon1(widget._typeCounter),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: _counter.value > 0 ? widget.color : AppColors.gray50,
                      size: _iconSize(context, widget._typeCounter),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _paddingText(
                      _counter.value.toInt().toString().length,
                      widget._typeCounter,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'x ',
                        style: APTextStyle.displayMD.bold.copyWith(color: widget.color),
                      ),
                      AppAnimatedCounter(
                        duration: const Duration(milliseconds: 200),
                        value: _counter.value.toInt(),
                        textStyle: APTextStyle.displayMD.bold.copyWith(color: widget.color),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _counter.value < 1000 ? _onIncrement : null,
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      vertical: _paddingVerticalIcon(context, widget._typeCounter),
                      horizontal: _onDelete.value == false && animation.value < 5
                          ? _paddingHorizontalIcon1(widget._typeCounter)
                          : _paddingHorizontalIcon2(widget._typeCounter),
                    ),
                    child: Icon(
                      Icons.delete_outline_outlined,
                      color: _counter.value < 1000 ? widget.color : AppColors.gray50,
                      size: _iconSize(context, widget._typeCounter),
                    ),
                  ),
                )
              ],
            )
          ],
        );

      case _TypeCounter.light:
        return Stack(
          key: widget.key,
          children: [
            Material(
              color: Colors.transparent,
              child: Ink(
                  width: double.infinity,
                  height: _heightBackDeleteButton(context, widget._typeCounter),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius(widget._typeCounter)),
                    color: AppColors.secondary.shade300,
                  ),
                  child: InkWell(
                    highlightColor: AppColors.whitePure.withOpacity(0.1),
                    splashColor: AppColors.whitePure.withOpacity(0.5),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_borderRadius(widget._typeCounter)),
                    ),
                    onTap: () => {widget.onDelete!(), HapticFeedback.lightImpact()},
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.delete_outline_outlined,
                            color: AppColors.whitePure,
                            size: _iconSize(context, widget._typeCounter),
                          ),
                        )),
                  )),
            ),
            Row(
              children: [
                Expanded(flex: animation.value, child: Container()),
                Expanded(
                  flex: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whitePure,
                      borderRadius: BorderRadius.circular(_borderRadius(widget._typeCounter)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(_borderRadius(widget._typeCounter)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _onDelete.value == false && animation.value < 5
                              ? GestureDetector(
                                  onTap: _onDecrement,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: _paddingVerticalIcon(context, widget._typeCounter),
                                          horizontal: _paddingHorizontalIcon1(widget._typeCounter)),
                                      child: _counter.value > 1
                                          ? Icon(
                                              Icons.remove,
                                              color: widget.color,
                                              size: _iconSize(context, widget._typeCounter),
                                            )
                                          : Icon(
                                              Icons.delete_outline_outlined,
                                              color: widget.color,
                                              size: _iconSize(context, widget._typeCounter),
                                            )),
                                )
                              : Container(),
                          _onDelete.value == false && animation.value < 5
                              ? Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: _paddingText(_counter.value.toInt().toString().length, widget._typeCounter)),
                                  child: AppAnimatedCounter(
                                    duration: const Duration(milliseconds: 200),
                                    value: _counter.value.toInt(),
                                    textStyle: APTextStyle.textXL.bold.copyWith(
                                      color: widget.color,
                                    ),
                                  ),
                                )
                              : Container(),
                          GestureDetector(
                            onTap: _onIncrement,
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  vertical: _paddingVerticalIcon(context, widget._typeCounter),
                                  horizontal: _onDelete.value == false && animation.value < 5
                                      ? _paddingHorizontalIcon1(widget._typeCounter)
                                      : _paddingHorizontalIcon2(widget._typeCounter)),
                              child: Icon(
                                Icons.add,
                                color: widget.color,
                                size: _iconSize(context, widget._typeCounter),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      case _TypeCounter.wihtoutDelete:
        return Stack(
          key: widget.key,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whitePure,
                    borderRadius: BorderRadius.circular(_borderRadius(widget._typeCounter)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(_borderRadius(widget._typeCounter)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _counter.value > 1 ? _onDecrement : null,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: _paddingVerticalIcon(context, widget._typeCounter),
                                  horizontal: _paddingHorizontalIcon1(widget._typeCounter)),
                              child: Icon(
                                Icons.remove,
                                color: _counter.value > 1 ? widget.color : widget.color.withOpacity(0.3),
                                size: _iconSize(context, widget._typeCounter),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: _paddingText(_counter.value.toInt().toString().length, widget._typeCounter)),
                          child: AppAnimatedCounter(
                            duration: const Duration(milliseconds: 200),
                            value: _counter.value.toInt(),
                            textStyle: APTextStyle.textXL.bold.copyWith(
                              color: widget.color,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _onIncrement,
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                vertical: _paddingVerticalIcon(context, widget._typeCounter),
                                horizontal: _onDelete.value == false && animation.value < 5
                                    ? _paddingHorizontalIcon1(widget._typeCounter)
                                    : _paddingHorizontalIcon2(widget._typeCounter)),
                            child: Icon(
                              Icons.add,
                              color: widget.color,
                              size: _iconSize(context, widget._typeCounter),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        );
    }
  }
}

/// A changing value. Initial value is false.
abstract class Metric {
  String get name;
  String get description;
}

class Boolean implements Metric {
  @override
  String name;
  @override
  String description;
  bool value = false;

  Boolean(this.name, this.description);
}

class Counter implements Metric {
  @override
  String name;
  @override
  String description;
  double value = 1;

  Counter(this.name, this.description);
}

enum _TypeCounter { small, normal, form, light, wihtoutDelete }

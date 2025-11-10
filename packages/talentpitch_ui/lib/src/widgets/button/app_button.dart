import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template app_button}
/// Button with text displayed in the application.
/// {@endtemplate}
class AppButton extends StatelessWidget {
  /// {@macro app_button}
  const AppButton._({
    required this.title,
    this.onPressed,
    this.icon,
    Color? buttonColor,
    Color? disabledButtonColor,
    Color? foregroundColor,
    Color? disabledForegroundColor,
    BorderSide? borderSide,
    double? elevation,
    TextStyle? textStyle,
    Size? maximumSize,
    Size? minimumSize,
    EdgeInsets? padding,
    Color? colorTitle,
    super.key,
  })  : _buttonColor = buttonColor ?? Colors.white,
        _disabledButtonColor = disabledButtonColor ?? AppColors.gray100,
        _borderSide = borderSide,
        _foregroundColor = foregroundColor ?? AppColors.black,
        _disabledForegroundColor = disabledForegroundColor ?? AppColors.white,
        _elevation = elevation ?? 0,
        _textStyle = textStyle,
        _maximumSize = maximumSize ?? _defaultMaximumSize,
        _minimumSize = minimumSize ?? _defaultMinimumSize,
        _colorTitle = colorTitle ?? AppColors.white,
        _padding = padding ?? _defaultPadding;

  /// Filled black button.
  const AppButton.primary({
    required String title,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    IconData? icon,
    EdgeInsets? padding,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.secondary,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
          icon: icon,
          title: title,
          colorTitle: AppColors.white,
          padding: padding,
        );

  /// Filled secondary button.
  const AppButton.secondary({
    required String title,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    Color? disabledButtonColor,
    IconData? icon,
    EdgeInsets? padding,
    Size? minimumSize,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.white,
          foregroundColor: AppColors.secondary,
          disabledButtonColor: disabledButtonColor ?? AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
          padding: padding,
          icon: icon,
          title: title,
          colorTitle: AppColors.secondary,
          minimumSize: minimumSize,
        );

  /// Filled secondary button.
  const AppButton.secondaryAlt({
    required String title,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    Color? disabledButtonColor,
    IconData? icon,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.grey,
          foregroundColor: AppColors.secondary,
          disabledButtonColor: disabledButtonColor ?? AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
          padding: _smallPadding,
          minimumSize: _smallMinimumSize,
          icon: icon,
          title: title,
          colorTitle: AppColors.secondary,
        );

  /// Filled secondary button.
  const AppButton.teartiary({
    required String title,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    Color? disabledButtonColor,
    IconData? icon,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.transparent,
          foregroundColor: AppColors.secondary,
          disabledButtonColor: disabledButtonColor ?? AppColors.transparent,
          elevation: elevation,
          textStyle: textStyle,
          padding: _smallPaddingTitle,
          minimumSize: _smallMinimum,
          icon: icon,
          title: title,
          colorTitle: onPressed != null ? AppColors.secondary : AppColors.grey,
        );

  /// The maximum size of the small variant of the button.
  static const _smallMinimum = Size(0, 32);

  /// The minimum size of the small variant of the button.
  static const _smallMinimumSize = Size(double.infinity, 32);

  /// The maximum size of the button.
  static const _defaultMaximumSize = Size(double.infinity, kIsWeb ? 56 : 48);

  /// The minimum size of the button.
  static const _defaultMinimumSize = Size(double.infinity, kIsWeb ? 56 : 48);

  /// The padding of the small variant of the button.
  static const _smallPadding = EdgeInsets.symmetric(horizontal: AppSpacing.xlg);
  static const _smallPaddingTitle = EdgeInsets.symmetric(horizontal: AppSpacing.xs);

  /// The padding of the the button.
  static const _defaultPadding = EdgeInsets.symmetric();

  /// [VoidCallback] called when button is pressed.
  /// Button is disabled when null.
  final VoidCallback? onPressed;

  /// A background color of the button.
  ///
  /// Defaults to [Colors.white].
  final Color _buttonColor;

  /// A disabled background color of the button.
  ///
  /// Defaults to [AppColors.disabledButton].
  final Color? _disabledButtonColor;

  /// Color of the text, icons etc.
  ///
  /// Defaults to [AppColors.black].
  final Color _foregroundColor;

  /// Color of the disabled text, icons etc.
  ///
  /// Defaults to [AppColors.disabledForeground].
  final Color _disabledForegroundColor;

  /// A border of the button.
  final BorderSide? _borderSide;

  /// Elevation of the button.
  final double _elevation;

  /// [TextStyle] of the button text.
  ///
  /// Defaults to [TextTheme.labelLarge].
  final TextStyle? _textStyle;

  /// The maximum size of the button.
  ///
  /// Defaults to [_defaultMaximumSize].
  final Size _maximumSize;

  /// The minimum size of the button.
  ///
  /// Defaults to [_defaultMinimumSize].
  final Size _minimumSize;

  /// The padding of the button.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets _padding;

  /// [Widget] displayed on the button.
  final IconData? icon;
  final String title;
  final Color _colorTitle;

  @override
  Widget build(BuildContext context) {
    final textStyle = _textStyle ??
        UITextStyle.labels.label.copyWith(
          color: _colorTitle,
        );

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize: WidgetStateProperty.all(_maximumSize),
        padding: WidgetStateProperty.all(_padding),
        minimumSize: WidgetStateProperty.all(_minimumSize),
        textStyle: WidgetStateProperty.all(textStyle),
        backgroundColor:
            onPressed == null ? WidgetStateProperty.all(_disabledButtonColor) : WidgetStateProperty.all(_buttonColor),
        elevation: WidgetStateProperty.all(_elevation),
        foregroundColor: onPressed == null
            ? WidgetStateProperty.all(_disabledForegroundColor)
            : WidgetStateProperty.all(_foregroundColor),
        side: WidgetStateProperty.all(_borderSide),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: icon != null,
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Icon(
                icon,
                color: _colorTitle,
              ),
            ),
          ),
          Text(
            title,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

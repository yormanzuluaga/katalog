// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class AppModal extends StatefulWidget {
  AppModal._({
    required this.title,
    String? subTitle,
    VoidCallback? onPressedPrimary,
    VoidCallback? onPressedSecondary,
    String? image,
    String? buttonTitle,
    String? buttonSubTitle,
    String? link,
    IconData? icon,
    bool? checkboxValue,
    Function(bool)? onCheckboxChange,
    String? errorMessage,
    String? checkboxLabel,
    String? checkboxLinkLabel,
    VoidCallback? onLinkTapped,
    bool? avoidBackButton,
    bool showCloseIcon = false,
    List<InlineSpan>? textSpans,
    super.key,
  })  : _subTitle = subTitle,
        _onPressedPrimary = onPressedPrimary,
        _onPressedSecondary = onPressedSecondary,
        _image = image,
        _buttonTitle = buttonTitle,
        _buttonSubTitle = buttonSubTitle,
        _link = link,
        _icon = icon,
        _checkboxValue = checkboxValue,
        _onCheckboxChange = onCheckboxChange,
        _checkboxLabel = checkboxLabel,
        _checkboxLinkLabel = checkboxLinkLabel,
        _errorMessage = errorMessage,
        _onLinktapped = onLinkTapped,
        _avoidBackButton = avoidBackButton ?? false,
        _showCloseIcon = showCloseIcon,
        _textSpans = textSpans;

  /// Filled black button.
  AppModal.doubleButton({
    Key? key,
    required String title,
    required VoidCallback onPressedPrymary,
    required VoidCallback onPressedSecondary,
    required String buttonTitle,
    required String buttonSubTitle,
    String? subTitle,
    List<InlineSpan>? textSpans,
    String? link,
    IconData? icon,
    bool? showCloseIcon,
  }) : this._(
            key: key,
            title: title,
            subTitle: subTitle,
            onPressedPrimary: onPressedPrymary,
            onPressedSecondary: onPressedSecondary,
            buttonTitle: buttonTitle,
            buttonSubTitle: buttonSubTitle,
            link: link,
            icon: icon,
            showCloseIcon: showCloseIcon ?? false,
            textSpans: textSpans);

  /// Filled black button.
  AppModal.doubleButtonWithCloseIcon({
    Key? key,
    required String title,
    required String subTitle,
    required VoidCallback onPressedPrymary,
    required VoidCallback onPressedSecondary,
    required String buttonTitle,
    required String buttonSubTitle,
    String? link,
    IconData? icon,
  }) : this._(
          key: key,
          title: title,
          subTitle: subTitle,
          onPressedPrimary: onPressedPrymary,
          onPressedSecondary: onPressedSecondary,
          buttonTitle: buttonTitle,
          buttonSubTitle: buttonSubTitle,
          link: link,
          icon: icon,
        );

  /// Filled secondary button.
  AppModal.oneButton({
    Key? key,
    required String title,
    String? subTitle,
    String? link,
    required VoidCallback onPressedPrymary,
    required String buttonTitle,
    List<InlineSpan>? textSpans,
    IconData? icon,
  }) : this._(
          key: key,
          title: title,
          subTitle: subTitle,
          link: link,
          onPressedPrimary: onPressedPrymary,
          buttonTitle: buttonTitle,
          icon: icon,
          textSpans: textSpans,
        );

  AppModal.text({
    Key? key,
    required String title,
    required String subTitle,
    String? link,
    IconData? icon,
  }) : this._(
          key: key,
          title: title,
          subTitle: subTitle,
          link: link,
          icon: icon,
        );

  AppModal.image({
    Key? key,
    required String title,
    required String subTitle,
    String? link,
    required String image,
  }) : this._(
          key: key,
          image: image,
          title: title,
          subTitle: subTitle,
          link: link,
        );

  AppModal.checkboxWithLink({
    Key? key,
    required String title,
    required String subTitle,
    required VoidCallback onPressedPrimary,
    required String buttonTitle,
    required Function(bool) onCheckboxChange,
    required bool checkboxValue,
    required String errorMessage,
    required String checkboxLabel,
    required String checkboxLinkLabel,
    required VoidCallback onLinkTapped,
    required bool avoidBackButton,
  }) : this._(
          key: key,
          title: title,
          subTitle: subTitle,
          onPressedPrimary: onPressedPrimary,
          buttonTitle: buttonTitle,
          checkboxValue: checkboxValue,
          onCheckboxChange: onCheckboxChange,
          errorMessage: errorMessage,
          checkboxLabel: checkboxLabel,
          checkboxLinkLabel: checkboxLinkLabel,
          onLinkTapped: onLinkTapped,
          avoidBackButton: avoidBackButton,
        );

  final VoidCallback? _onPressedPrimary;

  final VoidCallback? _onPressedSecondary;

  final String? _image;

  final String? _buttonTitle;

  final String? _buttonSubTitle;

  final String title;
  final String? _subTitle;
  final String? _link;
  final IconData? _icon;
  final bool _showCloseIcon;

  bool? _checkboxValue;
  final Function(bool)? _onCheckboxChange;
  final String? _checkboxLabel;
  final String? _checkboxLinkLabel;
  final VoidCallback? _onLinktapped;
  final String? _errorMessage;

  final bool? _avoidBackButton;

  final List<InlineSpan>? _textSpans;

  @override
  State<AppModal> createState() => _AppModalState();
}

class _AppModalState extends State<AppModal> {
  bool _errorActive = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return PopScope(
        onPopInvoked: (_) => _onWillPop,
        child: Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            width: constraints.minWidth > 900 ? 832 : double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: widget._onPressedPrimary != null ? AppSpacing.lg : AppSpacing.md,
                  ),
                  Visibility(
                    visible: !kIsWeb && widget._icon != null && widget._onPressedPrimary != null ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          widget._icon,
                          size: 42,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget._showCloseIcon && !kIsWeb,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 24.0,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget._onPressedPrimary != null ? false : true,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: widget._icon != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    widget._icon,
                                    size: 42,
                                    color: AppColors.black,
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.close,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.primary,
                              ),
                            ),
                    ),
                  ),
                  kIsWeb
                      ? Row(
                          children: [
                            Visibility(
                              visible: widget._icon != null && widget._onPressedPrimary != null ? true : false,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 12,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    widget._icon,
                                    size: 42,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.title,
                                  style: UITextStyle.titles.title2Medium.copyWith(color: AppColors.black),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget._showCloseIcon,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.close,
                                    size: 24,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title,
                            style: UITextStyle.titles.title2Medium.copyWith(color: AppColors.black),
                          ),
                        ),
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SubTitleText(subTitle: widget._subTitle, link: widget._link, textSpans: widget._textSpans),
                  ),
                  const SizedBox(height: AppSpacing.xlg),
                  Visibility(
                    visible: widget._checkboxValue != null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          AppSelection.checkboxWithLink(
                            label: widget._checkboxLabel ?? '',
                            linkLabel: widget._checkboxLinkLabel ?? '',
                            valueCheckbox: widget._checkboxValue ?? false,
                            errorActive: _errorActive,
                            onChanged: (value) {
                              widget._onCheckboxChange!(value);
                              widget._checkboxValue = value;
                              if (_errorActive && value) {
                                _errorActive = false;
                              }
                              setState(() {});
                            },
                            onLinkTapped: widget._onLinktapped ?? () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  constraints.maxWidth > 900
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 48,
                              width: 272,
                              child: Visibility(
                                visible: widget._onPressedSecondary != null ? true : false,
                                child: AppButton.secondary(
                                  onPressed: widget._onPressedSecondary,
                                  title: widget._buttonSubTitle.toString(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget._onPressedSecondary != null ? true : false,
                              child: const SizedBox(width: AppSpacing.lg),
                            ),
                            SizedBox(
                              height: 48,
                              width: 272,
                              child: Visibility(
                                visible: widget._onPressedPrimary != null ? true : false,
                                child: AppButton.primary(
                                  onPressed: widget._checkboxValue == null ? widget._onPressedPrimary : _checkBoxSubmit,
                                  title: widget._buttonTitle.toString(),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  constraints.maxWidth < 900
                      ? Visibility(
                          visible: widget._onPressedPrimary != null ? true : false,
                          child: AppButton.primary(
                            onPressed: widget._checkboxValue == null ? widget._onPressedPrimary : _checkBoxSubmit,
                            title: widget._buttonTitle.toString(),
                          ),
                        )
                      : Container(),
                  constraints.maxWidth < 900
                      ? Visibility(
                          visible: widget._onPressedSecondary != null ? true : false,
                          child: const SizedBox(height: AppSpacing.lg),
                        )
                      : Container(),
                  constraints.maxWidth < 900
                      ? Visibility(
                          visible: widget._onPressedSecondary != null ? true : false,
                          child: AppButton.secondary(
                            onPressed: widget._onPressedSecondary,
                            title: widget._buttonSubTitle.toString(),
                          ),
                        )
                      : Container(),
                  Visibility(
                      visible: widget._onPressedPrimary != null ? true : false,
                      child: const SizedBox(height: AppSpacing.xlg)),
                  Visibility(
                    visible: widget._image != null ? true : false,
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryMain,
                        image: DecorationImage(
                          image: AssetImage(widget._image.toString()),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget._image != null ? true : false,
                    child: const SizedBox(height: AppSpacing.xlg),
                  ),
                  Visibility(
                      visible: _errorActive,
                      child: AppModalError(
                        errorMessage: widget._errorMessage ?? '',
                      ))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<bool> _onWillPop() => Future.delayed(Duration.zero, (() => widget._avoidBackButton! ? false : true));

  _checkBoxSubmit() {
    if (!widget._checkboxValue!) {
      _errorActive = true;
      setState(() {});
      return;
    } else {
      _errorActive = false;
      setState(() {});
      widget._onPressedPrimary!();
    }
  }
}

class SubTitleText extends StatelessWidget {
  const SubTitleText({
    super.key,
    this.subTitle,
    this.link,
    this.textSpans,
  });

  final String? subTitle;
  final String? link;
  final List<InlineSpan>? textSpans;

  @override
  Widget build(BuildContext context) {
    if (subTitle != null && textSpans != null) {
      return ErrorWidget(
          'SubTitleText: You must use one of the following properties: subTitle or textSpans, no both of them. Nor any of them.');
    }

    if (textSpans != null) {
      return RichText(
        text: TextSpan(
          children: textSpans,
        ),
      );
    }

    if (link != null) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: subTitle, style: UITextStyle.paragraphs.paragraph2Medium.copyWith(color: AppColors.black)),
            TextSpan(text: link, style: UITextStyle.paragraphs.paragraph2Medium.copyWith(color: AppColors.primaryMain)),
          ],
        ),
      );
    }

    return Text(
      subTitle ?? '',
      style: UITextStyle.paragraphs.paragraph2Medium.copyWith(color: AppColors.black),
    );
  }
}

// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class WebModal extends StatefulWidget {
  WebModal._({
    required this.webModalType,
    required this.title,
    required this.subTitle,
    String? token,
    VoidCallback? onPressedPrimary,
    bool? checkboxValue,
    Function(bool)? onCheckboxChange,
    String? checkboxLabel,
    String? checkboxLinkLabel,
    VoidCallback? onLinkTapped,
    bool? avoidBackButton,
    String? errorMessage,
    Image? image,
    String? buttonTitle,
    String? termsNConditionsText,
    super.key,
  })  : _onPressedPrimary = onPressedPrimary,
        _token = token,
        _checkboxValue = checkboxValue,
        _onCheckboxChange = onCheckboxChange,
        _checkboxLabel = checkboxLabel,
        _checkboxLinkLabel = checkboxLinkLabel,
        _onLinkTapped = onLinkTapped,
        _avoidBackButton = avoidBackButton,
        _errorMessage = errorMessage,
        _buttonTitle = buttonTitle,
        _termsNConditionsText = termsNConditionsText;

  WebModal.showToken({
    Key? key,
    required String title,
    required String subTitle,
    required String token,
    required VoidCallback onPressedPrimary,
  }) : this._(
            key: key,
            title: title,
            subTitle: subTitle,
            token: token,
            onPressedPrimary: onPressedPrimary,
            webModalType: WebModalType.token);

  WebModal.checkboxWithLink({
    Key? key,
    required String title,
    required String subTitle,
    required bool checkboxValue,
    required Function(bool) onCheckboxChange,
    required String checkboxLabel,
    required String checkboxLinkLabel,
    VoidCallback? onLinkTapped,
    required bool avoidBackButton,
    required String errorMessage,
    Image? image,
    required String buttonTitle,
    required VoidCallback onPressedPrimary,
    required String termsNConditionsText,
  }) : this._(
            key: key,
            title: title,
            subTitle: subTitle,
            checkboxValue: checkboxValue,
            onCheckboxChange: onCheckboxChange,
            checkboxLabel: checkboxLabel,
            checkboxLinkLabel: checkboxLinkLabel,
            onLinkTapped: onLinkTapped,
            avoidBackButton: avoidBackButton,
            errorMessage: errorMessage,
            image: image,
            buttonTitle: buttonTitle,
            onPressedPrimary: onPressedPrimary,
            termsNConditionsText: termsNConditionsText,
            webModalType: WebModalType.checkboxWithLink);

  final String title;
  final String subTitle;
  final String? _token;
  final VoidCallback? _onPressedPrimary;
  bool? _checkboxValue;
  final Function(bool)? _onCheckboxChange;
  final String? _checkboxLabel;
  final String? _checkboxLinkLabel;
  final VoidCallback? _onLinkTapped;
  final bool? _avoidBackButton;
  final String? _errorMessage;
  final String? _buttonTitle;
  final WebModalType webModalType;
  final String? _termsNConditionsText;

  @override
  State<WebModal> createState() => _WebModalState();
}

class _WebModalState extends State<WebModal> {
  bool _errorActive = false;
  bool _showTermsNConditions = false;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    switch (widget.webModalType) {
      case WebModalType.token:
        return LayoutBuilder(
          builder: (context, constraints) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: constraints.minWidth < 900
                  ? AppBottomsheet.showToken(
                      title: widget.title,
                      subTitle: widget.subTitle,
                      token: widget._token!,
                      onPressedPrimary: widget._onPressedPrimary!,
                    )
                  : Container(
                      padding: const EdgeInsets.all(AppSpacing.xlg),
                      width: constraints.minWidth > 900 ? 832 : double.infinity,
                      height: 174,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.title,
                                  style: UITextStyle.titles.title2Medium,
                                ),
                              ),
                              InkWell(
                                onTap: () => widget._onPressedPrimary!(),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.subTitle,
                              style: UITextStyle.paragraphs.paragraph1Regular,
                            ),
                          ),
                          Visibility(
                              visible: widget._token != null,
                              child: Column(
                                children: [
                                  const SizedBox(height: AppSpacing.xlgplus),
                                  Text(
                                    widget._token!,
                                    style: UITextStyle.titles.title1Medium.copyWith(
                                      color: AppColors.primaryMain,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),
        );
      case WebModalType.checkboxWithLink:
        return LayoutBuilder(
          builder: (context, constraints) => PopScope(
            onPopInvoked: (_) => _onWillPop,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spaceUnit * 3,
                  horizontal: AppSpacing.spaceUnit * 3.5,
                ),
                width: constraints.minWidth > 900 ? 832 : double.infinity,
                height: 710,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title,
                          style: UITextStyle.titles.title1Medium,
                        )),
                    const SizedBox(height: AppSpacing.sm),
                    Visibility(
                      visible: !_showTermsNConditions,
                      child: Expanded(
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.subTitle,
                                  style: UITextStyle.paragraphs.paragraph1Regular,
                                )),
                            const SizedBox(height: AppSpacing.spaceUnitPlus3),
                            const SizedBox(height: AppSpacing.spaceUnitPlus3),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _showTermsNConditions,
                      child: Expanded(
                          child: RawScrollbar(
                        radius: const Radius.circular(AppSpacing.sm),
                        thickness: 4.0,
                        thumbVisibility: true,
                        controller: _scrollController,
                        thumbColor: AppColors.primary,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: const EdgeInsets.only(right: AppSpacing.spaceUnit),
                              child: Text(
                                widget._termsNConditionsText ?? '',
                                style: UITextStyle.paragraphs.paragraph2Regular,
                              ),
                            ),
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppSelection.checkboxWithLink(
                          valueCheckbox: widget._checkboxValue!,
                          label: widget._checkboxLabel!,
                          linkLabel: widget._checkboxLinkLabel!,
                          errorActive: _errorActive,
                          onChanged: _onCheckboxChangedMethod,
                          onLinkTapped: widget._onLinkTapped ??
                              () {
                                _showTermsNConditions = true;
                                setState(() {});
                              },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpacing.xxlg,
                      child: _errorActive
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppModalError(errorMessage: widget._errorMessage!),
                              ],
                            )
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 208),
                      child: AppButton.primary(
                        title: widget._buttonTitle!,
                        onPressed: _checkBoxSubmit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }

  _onCheckboxChangedMethod(value) {
    widget._onCheckboxChange!(value);
    widget._checkboxValue = value;
    if (_errorActive && value) {
      _errorActive = false;
    }
    setState(() {});
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

enum WebModalType { token, checkboxWithLink }

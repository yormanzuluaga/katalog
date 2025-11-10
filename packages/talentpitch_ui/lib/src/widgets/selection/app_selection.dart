import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class AppSelection extends StatefulWidget {
  const AppSelection._({
    required this.typeSelection,
    bool? valueCheckbox,
    int? valueRadio,
    int? groupValueRadio,
    Function(bool)? onChanged,
    Function(int)? onRadioChanged,
    String? label,
    String? linkLabel,
    VoidCallback? onLinkTapped,
    TextStyle? textStyle,
    bool? errorActive,
    super.key,
  })  : _onChanged = onChanged,
        _onRadioChanged = onRadioChanged,
        _valueCheckbox = valueCheckbox ?? false,
        _valueRadio = valueRadio,
        _groupValueRadio = groupValueRadio,
        _label = label,
        _linkLabel = linkLabel,
        _onLinktapped = onLinkTapped,
        _textStyle = textStyle,
        _errorActive = errorActive;

  const AppSelection.checkbox({
    Key? key,
    bool? valueCheckbox,
    Function(bool)? onChanged,
    String? label,
    TextStyle? textStyle,
    bool? errorActive = false,
  }) : this._(
          key: key,
          valueCheckbox: valueCheckbox,
          onChanged: onChanged,
          typeSelection: TypeSelection.checkbox,
          label: label,
          textStyle: textStyle,
          errorActive: errorActive,
        );

  const AppSelection.checkboxWithLink({
    Key? key,
    required bool valueCheckbox,
    Function(bool)? onChanged,
    required String label,
    required String linkLabel,
    required VoidCallback onLinkTapped,
    TextStyle? textStyle,
    bool? errorActive = false,
  }) : this._(
          key: key,
          valueCheckbox: valueCheckbox,
          onChanged: onChanged,
          typeSelection: TypeSelection.checkboxWithLink,
          label: label,
          linkLabel: linkLabel,
          onLinkTapped: onLinkTapped,
          textStyle: textStyle,
          errorActive: errorActive,
        );

  const AppSelection.radio({
    Key? key,
    String? label,
    int? value,
    int? groupValue,
    Function(int? value)? onChanged,
  }) : this._(
          key: key,
          label: label,
          valueRadio: value,
          groupValueRadio: groupValue,
          onRadioChanged: onChanged,
          typeSelection: TypeSelection.radio,
        );

  final TypeSelection typeSelection;

  final String? _label;
  final String? _linkLabel;
  final bool _valueCheckbox;
  final int? _valueRadio;
  final int? _groupValueRadio;
  final bool? _errorActive;
  final Function(bool)? _onChanged;
  final Function(int)? _onRadioChanged;
  final VoidCallback? _onLinktapped;
  final TextStyle? _textStyle;

  @override
  State<AppSelection> createState() => _AppSelectionState();
}

class _AppSelectionState extends State<AppSelection> {
  final List<String> listOption = ['Option 1', 'Option 2'];

  final String currentOption = 'Option 1';

  int? currentValue = 1;

  @override
  Widget build(BuildContext context) {
    switch (widget.typeSelection) {
      case TypeSelection.checkboxWithLink:
        return Row(
          children: [
            Checkbox(
              side: BorderSide(
                color: widget._errorActive! ? AppColors.error : AppColors.black,
                width: 1.50,
              ),
              value: widget._valueCheckbox,
              onChanged: (value) {
                if (widget._onChanged != null) {
                  widget._onChanged!(value!);
                  setState(() {});
                }
              },
              fillColor: widget._onChanged != null
                  ? WidgetStateProperty.all(widget._valueCheckbox ? AppColors.primary : null)
                  : null,
            ),
            SizedBox(width: widget._label != null ? 8 : 0),
            widget._label != null
                ? kIsWeb
                    ? _buildCheckboxLabels()
                    : Expanded(
                        child: _buildCheckboxLabels(),
                      )
                : const SizedBox(),
          ],
        );
      case TypeSelection.checkbox:
        return InkWell(
          onTap: () {
            widget._onChanged!(!widget._valueCheckbox);
            setState(() {});
          },
          child: Row(
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: Checkbox(
                  side: BorderSide(
                    color: widget._errorActive! ? AppColors.error : AppColors.black,
                    width: 1.50,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  fillColor: widget._onChanged != null
                      ? WidgetStateProperty.all(widget._valueCheckbox ? AppColors.primaryMain : null)
                      : null,
                  value: widget._valueCheckbox,
                  checkColor: AppColors.white,
                  onChanged: (value) {
                    if (widget._onChanged != null) {
                      widget._onChanged!(value!);
                      setState(() {});
                    }
                  },
                ),
              ),
              SizedBox(width: widget._label != null ? 8 : 0),
              widget._label != null
                  ? Expanded(
                      child: Text(widget._label!,
                          style: widget._textStyle ??
                              UITextStyle.paragraphs.paragraph2Regular.copyWith(
                                color: widget._errorActive! ? AppColors.error : AppColors.black,
                              )),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      case TypeSelection.radio:
        onRadioChanged(newValue) {
          if (widget._onRadioChanged != null) {
            widget._onRadioChanged!(newValue!);
          }
          setState(() {
            currentValue = newValue;
          });
        }
        return Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 24,
                maxWidth: 24,
              ),
              child: Radio(
                value: widget._valueRadio,
                groupValue: widget._groupValueRadio,
                visualDensity: VisualDensity.comfortable,
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  return states.contains(WidgetState.selected) ? AppColors.primaryMain : AppColors.black;
                }),
                onChanged: onRadioChanged,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: InkWell(
                onTap: () => onRadioChanged(widget._valueRadio),
                child: Text(
                  widget._label ?? '',
                  style: UITextStyle.paragraphs.paragraph2Regular.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  RichText _buildCheckboxLabels() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: widget._label!,
              style: UITextStyle.paragraphs.paragraph2Regular.copyWith(
                color: widget._errorActive! ? AppColors.error : AppColors.black,
              )),
          TextSpan(
            text: ' ${widget._linkLabel}',
            recognizer: TapGestureRecognizer()..onTap = widget._onLinktapped,
            style: UITextStyle.paragraphs.paragraph2SemiBold.copyWith(color: AppColors.primaryMain),
          ),
        ],
      ),
    );
  }
}

enum TypeSelection { checkbox, checkboxWithLink, radio }

import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class AppBottomsheet extends StatefulWidget {
  const AppBottomsheet._({
    required this.appBottomsheetStyle,
    required this.title,
    required this.subTitle,
    VoidCallback? onPressedPrimary,
    String? token,
    super.key,
  })  : _onPressedPrimary = onPressedPrimary,
        _token = token;

  const AppBottomsheet.showToken({
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
          appBottomsheetStyle: AppBottomsheetStyle.token,
        );

  final String title;
  final String subTitle;
  final VoidCallback? _onPressedPrimary;
  final String? _token;
  final AppBottomsheetStyle appBottomsheetStyle;

  @override
  State<AppBottomsheet> createState() => _AppBottomsheetState();
}

class _AppBottomsheetState extends State<AppBottomsheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.appBottomsheetStyle) {
      // Mostrar token
      case AppBottomsheetStyle.token:
        return SizedBox(
          height: 232,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 64,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: UITextStyle.paragraphs.paragraph1SemiBold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: InkWell(
                            onTap: widget._onPressedPrimary,
                            child: const Icon(
                              Icons.close,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget._token != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 24),
                    child: Text(
                      widget._token!,
                      style: UITextStyle.titles.title1Medium.copyWith(color: AppColors.primaryMain),
                    ),
                  ),
                ),
                SizedBox(
                  width: 332,
                  child: Text(
                    widget.subTitle,
                    textAlign: TextAlign.center,
                    style: UITextStyle.paragraphs.paragraph1Regular,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}

enum AppBottomsheetStyle {
  token,
}

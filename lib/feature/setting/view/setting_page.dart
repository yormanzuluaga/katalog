import 'package:flutter/material.dart';
import 'package:talentpitch_test/feature/setting/view/setting_desktop.dart';
import 'package:talentpitch_test/feature/setting/view/setting_mobile.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MediaQuery.of(context).size.width > 900 ? SettingDesktop() : SettingMobile();
      },
    );
  }
}

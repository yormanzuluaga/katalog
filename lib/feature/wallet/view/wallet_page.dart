import 'package:flutter/material.dart';
import 'package:talentpitch_test/feature/wallet/view/wallet_desktop.dart';
import 'package:talentpitch_test/feature/wallet/view/wallet_mobile.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MediaQuery.of(context).size.width > 900 ? WalletDesktop() : WalletMobile();
      },
    );
  }
}

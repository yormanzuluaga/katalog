import 'package:flutter/material.dart';
import 'package:talentpitch_test/feature/cart/view/cart_desktop.dart';
import 'package:talentpitch_test/feature/cart/view/cart_mobile.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MediaQuery.of(context).size.width > 900 ? CartDesktop() : CartMobile();
      },
    );
  }
}

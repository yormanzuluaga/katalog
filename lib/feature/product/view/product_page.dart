import 'package:flutter/material.dart';
import 'package:talentpitch_test/feature/product/view/product_desktop.dart';
import 'package:talentpitch_test/feature/product/view/product_mobile.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MediaQuery.of(context).size.width > 900 ? ProductDesktop() : ProductMobile();
      },
    );
  }
}

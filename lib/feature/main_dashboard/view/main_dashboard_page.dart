import 'package:flutter/material.dart';
import 'package:talentpitch_test/feature/product/view/product_page.dart';

class MainDashboardPage extends StatelessWidget {
  const MainDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ProductPage();
      },
    );
  }
}

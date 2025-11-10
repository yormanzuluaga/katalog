// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:showcaseview/showcaseview.dart';
import 'package:talentpitch_test/feature/home/view/home_desktop.dart';
import 'package:talentpitch_test/feature/home/view/home_mobile.dart';
import 'package:talentpitch_test/feature/product/bloc/category/category_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.child,
    super.key,
  });
  final Widget child;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      disableBarrierInteraction: true,
      scrollDuration: const Duration(milliseconds: 5),
      disableMovingAnimation: true,
      enableAutoScroll: MediaQuery.of(context).size.height >= 700,
      builder: (_) => HomeView(
        child: widget.child,
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MediaQuery.of(context).size.width > 900 ? HomeDesktop(child: child) : HomeMobile(child: child);
        },
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes.dart';
import 'package:talentpitch_test/feature/product/bloc/category/category_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:flutter/material.dart';

class MainDashboardMobile extends StatelessWidget {
  MainDashboardMobile({super.key});
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: AppSpacing.sm,
              ),
            ],
          );
        },
      ),
    );
  }
}

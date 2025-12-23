import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talentpitch_test/feature/product/bloc/category/category_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class SubCategoryList extends StatelessWidget {
  const SubCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Align(
                child: Text(
                  'Subcategorías: ${state.subCategory?.subCategories?.length ?? 0}',
                  style: UITextStyle.labels.label.copyWith(
                    color: AppColors.primaryMain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.subCategory?.subCategories?.length ?? 0,
                  itemBuilder: (context, index) {
                    final category = state.subCategory!.subCategories![index];
                    return InkWell(
                      onTap: () {
                        context.read<CategoryBloc>().add(
                              GetProductEvent(
                                idProduct: category.id ?? '',
                                title: category.name,
                              ),
                            );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.whitePure,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.primaryMain.withOpacity(.2),
                                    blurRadius: 5,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: (category.img != null &&
                                          category.img!.isNotEmpty)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            category.img!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const FaIcon(
                                                FontAwesomeIcons.boxOpen,
                                                color: AppColors.primaryMain,
                                                size: 32,
                                              );
                                            },
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColors.primaryMain,
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : const FaIcon(
                                          FontAwesomeIcons.boxOpen,
                                          color: AppColors.primaryMain,
                                          size: 32,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.name ?? '',
                            textAlign: TextAlign.center,
                            style: APTextStyle.textSM.semibold.copyWith(
                              color: AppColors.secondaryDark,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

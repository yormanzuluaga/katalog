// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/product/bloc/category/category_bloc.dart';
import 'package:talentpitch_test/feature/banner/bloc/banner_bloc.dart';
import 'package:talentpitch_test/feature/banner/view/carousel_banner.dart';
import 'package:talentpitch_test/injection/injection_container.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class ProductMobile extends StatelessWidget {
  const ProductMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<BannerBloc>(),
        ),
      ],
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          final categoryCount = state.category?.category?.length ?? 0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: const CarouselBanner(),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categorías',
                        style: APTextStyle.textMD.bold.copyWith(
                          color: AppColors.primaryMain,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(RoutesNames.productList);
                        },
                        child: Row(
                          children: [
                            Text(
                              'Ver todas las categorías',
                              style: APTextStyle.textMD.bold.copyWith(
                                color: AppColors.primaryMain,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 20,
                              color: AppColors.primaryMain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (categoryCount == 0) return const SizedBox.shrink();
                      final category = state.category!.category![index];
                      return InkWell(
                        onTap: () {
                          if (category.isSubCatalogo ?? false) {
                            context.read<CategoryBloc>().add(
                                  GetSubCategoryEvent(
                                      idCategory: category.id ?? ''),
                                );
                            context.go(RoutesNames.subCategory);
                          } else {
                            context.read<CategoryBloc>().add(
                                  GetProductEvent(
                                    idProduct: category.id ?? '',
                                    title: category.name,
                                  ),
                                );
                          }
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
                                    ),
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
                                                    color:
                                                        AppColors.primaryMain,
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
                    childCount: categoryCount,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Marcas',
                          style: APTextStyle.textMD.bold.copyWith(
                            color: AppColors.primaryMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, categoryState) {
                    if (categoryState.brands == null) {
                      // Cargar marcas si no están disponibles
                      context.read<CategoryBloc>().add(const LoadBrandsEvent());
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    if (categoryState.message != null) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              categoryState.message ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      );
                    }

                    final brands = categoryState.brands!;

                    return SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final brand = brands[index];
                          return InkWell(
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                    LoadProductsByBrandEvent(
                                      brandId: brand.id,
                                      brandName: brand.name,
                                    ),
                                  );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.whitePure,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.primaryMain.withOpacity(.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (brand.logo != null &&
                                      brand.logo!.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        brand.logo!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const FaIcon(
                                            FontAwesomeIcons.tag,
                                            color: AppColors.primaryMain,
                                            size: 32,
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.primaryMain,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  else
                                    const FaIcon(
                                      FontAwesomeIcons.tag,
                                      color: AppColors.primaryMain,
                                      size: 32,
                                    ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      brand.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          APTextStyle.textXS.semibold.copyWith(
                                        color: AppColors.secondaryDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: brands.length,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

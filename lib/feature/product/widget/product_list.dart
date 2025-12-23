import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/cart/bloc/cart/cart_bloc.dart';
import 'package:talentpitch_test/feature/product/bloc/category/category_bloc.dart';
import 'package:talentpitch_test/feature/product/bloc/brand/brand_bloc.dart';
import 'package:talentpitch_test/feature/product/widget/product_variants_modal.dart';
import 'package:talentpitch_test/feature/product/widget/improved_product_card.dart';
import 'package:talentpitch_test/feature/catalog/widget/add_to_catalog_button.dart';
import 'package:talentpitch_test/feature/product/widget/horizontal_filters.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class ProductList extends StatefulWidget {
  final String id;
  final String title;
  final String info;
  final String? type; // 'brand' o 'category'

  const ProductList({
    super.key,
    required this.title,
    required this.id,
    required this.info,
    this.type,
  });

  @override
  ProductListState createState() => ProductListState();
}

class ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteTechnical,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, stateCart) {
            return Column(
              children: [
                const AppSearch(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Productos: ${widget.title}',
                    style: APTextStyle.textMD.semibold,
                  ),
                ),
                const SizedBox(height: 8),
                // Mostrar filtros solo para categorías (no para marcas)
                _buildFilters(),
                // Mostrar productos según el tipo (brand o category)
                _buildCategoryProducts(stateCart),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final filters = state.product?.availableFilters ?? [];
        final selectedFilter = state.selectedFilter;

        return HorizontalFilters(
          filters: filters,
          selectedFilter: selectedFilter,
          onFilterSelected: (filter) {
            context.read<CategoryBloc>().add(
                  FilterProductEvent(
                    idProduct: widget.id,
                    filter: filter,
                  ),
                );
          },
          onFilterCleared: () {
            context.read<CategoryBloc>().add(
                  ClearFilterEvent(idProduct: widget.id),
                );
          },
        );
      },
    );
  }

  Widget _buildBrandProducts(CartState stateCart) {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        // Mostrar error si hay un mensaje de error
        if (state.message != null) {
          return Expanded(
            child: Center(
              child: Text(
                state.message!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // Mostrar productos si existen
        if (state.products != null && state.products!.isNotEmpty) {
          return Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                final itemWidth =
                    (constraints.maxWidth - (12.0 * (crossAxisCount - 1))) /
                        crossAxisCount;

                return GridView.builder(
                  itemCount: state.products!.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    mainAxisExtent: _calculateItemHeight(itemWidth),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final product = state.products![index];
                    return _buildProductCard(product, stateCart, context);
                  },
                );
              },
            ),
          );
        }

        // Mostrar loading si no hay productos ni error
        if (state.products == null) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return const Expanded(
          child: Center(
            child: Text('No hay productos disponibles'),
          ),
        );
      },
    );
  }

  Widget _buildCategoryProducts(CartState stateCart) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        // Mostrar loading si no hay productos cargados aún
        if (state.product == null) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Mostrar productos
        if (state.product!.product != null &&
            state.product!.product!.isNotEmpty) {
          return Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                final itemWidth =
                    (constraints.maxWidth - (12.0 * (crossAxisCount - 1))) /
                        crossAxisCount;

                return GridView.builder(
                  itemCount: state.product!.product!.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    mainAxisExtent: _calculateItemHeight(itemWidth),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final product = state.product!.product![index];
                    return _buildProductCard(product, stateCart, context);
                  },
                );
              },
            ),
          );
        }

        return const Expanded(
          child: Center(
            child: Text('No hay productos disponibles'),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(
      Product product, CartState stateCart, BuildContext context) {
    final salePrice = product.pricing?.salePrice?.toDouble() ?? 0.0;
    final costPrice = product.pricing?.costPrice?.toDouble() ?? 0.0;
    final commission = product.pricing?.commission?.toDouble() ?? 0.0;
    final wholesaleCommission =
        product.pricing?.wholesaleCommission?.toDouble();

    // Calcular total de unidades en el carrito
    int totalUnits = 0;
    if (stateCart.listSale != null) {
      for (var item in stateCart.listSale!) {
        totalUnits += item.quantity ?? 1;
      }
    }
    final isWholesale = totalUnits >= 6;

    return ImprovedProductCard(
      title: product.name ?? 'Producto',
      subtitle: product.brand?.name ?? '',
      imageUrl: product.img,
      salePrice: salePrice,
      costPrice: costPrice,
      commission: commission,
      wholesaleCommission: wholesaleCommission,
      isWholesale: isWholesale,
      discount: product.discount?.toString(),
      catalogButton: AddToCatalogButton(product: product),
      onTap: () {
        context.push(RoutesNames.detail, extra: [product]);
      },
      actionButton: Builder(
        builder: (context) {
          if (product.productType == 'simple') {
            final productInCart = stateCart.listSale?.firstWhere(
              (cartProduct) => cartProduct.id == product.id,
              orElse: () => Product(),
            );

            final isProductInCart = productInCart?.id == product.id;
            final quantity = productInCart?.quantity ?? 1;

            return (isProductInCart)
                ? SizedBox(
                    height: 45,
                    child: AppCounters.normal(
                      key: ValueKey('counter_${product.id}'),
                      initialValue: quantity,
                      onDelete: () {
                        context.read<CartBloc>().add(
                              DeletedCartEvent(id: product.id ?? ''),
                            );
                      },
                      onChange: (value) {
                        context.read<CartBloc>().add(
                              CountCartEvent(
                                id: product.id ?? '',
                                quantity: value,
                              ),
                            );
                      },
                    ),
                  )
                : MaterialButton(
                    key: ValueKey('add_btn_${product.id}'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minWidth: double.infinity,
                    elevation: 0,
                    height: 42.0,
                    color: AppColors.secondary,
                    onPressed: () {
                      context.read<CartBloc>().add(
                            AddCartEvent(
                              productsSalesModel: product,
                            ),
                          );
                    },
                    child: Text(
                      'Agregar',
                      style: APTextStyle.textSM.bold
                          .copyWith(color: AppColors.whitePure),
                    ),
                  );
          } else {
            return MaterialButton(
              key: ValueKey('variants_btn_${product.id}'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minWidth: double.infinity,
              elevation: 0,
              height: 42.0,
              color: AppColors.secondary,
              onPressed: () {
                _showProductVariantsModal(context, product);
              },
              child: Text(
                'Agregar',
                style: APTextStyle.textSM.bold
                    .copyWith(color: AppColors.whitePure),
              ),
            );
          }
        },
      ),
    );
  }

  double _calculateItemHeight(double itemWidth) {
    final imageHeight = itemWidth * 0.75;
    final titleHeight = 45.0; // Aumentado para 2 líneas de título
    final subtitleHeight = 20.0;
    final priceHeight = 75.0; // Aumentado para badge y comisión con tachado
    final buttonHeight = 50.0;
    final cardPadding = 30.0; // Más espacio interno

    return imageHeight +
        titleHeight +
        subtitleHeight +
        priceHeight +
        buttonHeight +
        cardPadding;
  }

  void _showProductVariantsModal(BuildContext context, Product product) {
    showAppBottomsheet(
      context: context,
      builder: (BuildContext modalContext) => ProductVariantsModal(
        product: product,
        onVariantSelected: (selectedVariant) {
          final variantId =
              _generateVariantId(product.id ?? '', selectedVariant);

          final productWithVariant = product.copyWith(
            id: variantId,
            pricing: selectedVariant.pricing ?? product.pricing,
            variants: [selectedVariant],
          );

          print(
              '🛒 ProductList: Agregando producto con variante - ID: $variantId');
          print(
              '🎨 ProductList: Color: ${selectedVariant.color?.name}, Tamaño: ${selectedVariant.size}');

          context.read<CartBloc>().add(
                AddCartEvent(
                  productsSalesModel: productWithVariant,
                ),
              );

          Navigator.of(modalContext).pop();
        },
      ),
    );
  }

  String _generateVariantId(String baseId, Variant variant) {
    final List<String> parts = [baseId];

    if (variant.color?.name != null) {
      parts.add(
          'color_${variant.color!.name!.toLowerCase().replaceAll(' ', '_')}');
    }
    if (variant.size != null) {
      parts.add(
          'size_${variant.size.toString().toLowerCase().replaceAll(' ', '_')}');
    }
    if (variant.sku != null) {
      parts.add('sku_${variant.sku!.toLowerCase().replaceAll(' ', '_')}');
    }

    return parts.join('_');
  }
}

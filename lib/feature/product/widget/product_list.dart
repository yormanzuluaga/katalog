import 'package:api_helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/cart/bloc/cart/cart_bloc.dart';
import 'package:talentpitch_test/feature/product/bloc/category/category_bloc.dart';
import 'package:talentpitch_test/feature/product/widget/product_variants_modal.dart';
import 'package:talentpitch_test/feature/product/widget/improved_product_card.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class ProductList extends StatefulWidget {
  final String id;
  final String title;
  final String info;

  const ProductList({
    super.key,
    required this.title,
    required this.id,
    required this.info,
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
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    return Flexible(
                      child: GridView.builder(
                          itemCount: state.product?.product?.length ?? 0,
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final product = state.product!.product![index];
                            // Calcular valores
                            final salePrice = product.pricing?.salePrice?.toDouble() ?? 0.0;
                            final costPrice = product.pricing?.costPrice?.toDouble() ?? 0.0;
                            final commission = product.pricing?.commission?.toDouble() ?? 0.0;

                            return ImprovedProductCard(
                              title: product.name ?? 'Producto',
                              subtitle: product.brand?.name ?? '',
                              imageUrl: product.img,
                              salePrice: salePrice,
                              costPrice: costPrice,
                              commission: commission,
                              discount: product.discount?.toString(),
                              onTap: () {
                                context.push(RoutesNames.detail, extra: [product]);
                              },
                              actionButton: Builder(
                                builder: (context) {
                                  // Para productos simples, verificar si está en el carrito
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
                                              style: APTextStyle.textSM.bold.copyWith(color: AppColors.whitePure),
                                            ),
                                          );
                                  } else {
                                    // Para productos con variantes, siempre mostrar botón "Ver opciones"
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
                                        style: APTextStyle.textSM.bold.copyWith(color: AppColors.whitePure),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }),
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void _showProductVariantsModal(BuildContext context, Product product) {
    showAppBottomsheet(
      context: context,
      builder: (BuildContext modalContext) => ProductVariantsModal(
        product: product,
        onVariantSelected: (selectedVariant) {
          // Generar un ID único que incluya la información de la variante
          final variantId = _generateVariantId(product.id ?? '', selectedVariant);

          // Crear un producto modificado con la variante seleccionada
          final productWithVariant = product.copyWith(
            id: variantId,
            pricing: selectedVariant.pricing ?? product.pricing,
            // Mantener la referencia a la variante seleccionada
            variants: [selectedVariant],
          );

          print('🛒 ProductList: Agregando producto con variante - ID: $variantId');
          print('🎨 ProductList: Color: ${selectedVariant.color?.name}, Tamaño: ${selectedVariant.size}');

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

  /// Genera un ID único para la variante del producto
  String _generateVariantId(String baseId, Variant variant) {
    final List<String> parts = [baseId];

    // Agregar características de la variante al ID
    if (variant.color?.name != null) {
      parts.add('color_${variant.color!.name!.toLowerCase().replaceAll(' ', '_')}');
    }
    if (variant.size != null) {
      parts.add('size_${variant.size.toString().toLowerCase().replaceAll(' ', '_')}');
    }
    if (variant.sku != null) {
      parts.add('sku_${variant.sku!.toLowerCase().replaceAll(' ', '_')}');
    }

    return parts.join('_');
  }
}

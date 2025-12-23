import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/cart/bloc/cart/cart_bloc.dart';
import 'package:talentpitch_test/feature/cart/widget/improved_cart_item.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class CartMobile extends StatefulWidget {
  const CartMobile({super.key});

  @override
  CartMobileState createState() => CartMobileState();
}

class CartMobileState extends State<CartMobile>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late int quantityData;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    super.initState();
  }

  int _calculateTotalUnits(CartState state) {
    if (state.listSale == null || state.listSale!.isEmpty) {
      return 0;
    }

    int totalUnits = 0;
    for (var product in state.listSale!) {
      totalUnits += product.quantity ?? 1;
    }
    return totalUnits;
  }

  String _calculateTotalProfit(CartState state) {
    if (state.listSale == null || state.listSale!.isEmpty) {
      return '0';
    }

    final totalUnits = _calculateTotalUnits(state);
    final isWholesale = totalUnits >= 6;

    double totalProfit = 0;
    for (var product in state.listSale!) {
      final commission = isWholesale
          ? (product.pricing?.wholesaleCommission?.toDouble() ??
              product.pricing?.commission?.toDouble() ??
              0.0)
          : (product.pricing?.commission?.toDouble() ?? 0.0);
      final quantity = product.quantity ?? 1;
      final profit = commission * quantity;
      totalProfit += profit;
    }

    return addDotsToNumber(totalProfit.toInt());
  }

  int _calculateFinalTotal(CartState state) {
    if (state.listSale == null || state.listSale!.isEmpty) {
      return 0;
    }

    final subtotal = int.parse(double.parse(state.sumTotal).toStringAsFixed(0));
    final shippingCost = subtotal >= 100000 ? 0 : 15000;

    return subtotal + shippingCost;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Text(
                    //   state.listSale != null && state.listSale!.isNotEmpty
                    //       ? 'Productos: ${state.listSale!.length}'
                    //       : 'No hay productos',
                    //   style: APTextStyle.textSM.medium.copyWith(
                    //     color: AppColors.gray80,
                    //     fontSize: 14,
                    //   ),
                    // ),
                    //SizedBox(height: 16),
                    Flexible(
                      child: state.listSale != null &&
                              state.listSale!.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.all(0.0),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.listSale!.length,
                              itemBuilder: (context, index) {
                                final data = state.listSale![index];

                                // Obtener información de la variante si está disponible
                                String variantInfo = '';
                                if (data.variants != null &&
                                    data.variants!.isNotEmpty) {
                                  final variant = data.variants!.first;
                                  List<String> variantDetails = [];

                                  if (variant.color?.name != null) {
                                    variantDetails
                                        .add('Color: ${variant.color!.name}');
                                  }
                                  if (variant.size != null) {
                                    variantDetails
                                        .add('Talla: ${variant.size}');
                                  }

                                  variantInfo = variantDetails.join(' • ');
                                } else if (data.id != null &&
                                    data.id!.contains('color_')) {
                                  // Si no hay variantes explícitas, extraer del ID
                                  final idParts = data.id!.split('_');
                                  for (int i = 0; i < idParts.length; i++) {
                                    if (idParts[i] == 'color' &&
                                        i + 1 < idParts.length) {
                                      variantInfo =
                                          'Color: ${idParts[i + 1].replaceAll('_', ' ')}';
                                      break;
                                    }
                                  }
                                }

                                final totalUnits = _calculateTotalUnits(state);
                                final isWholesale = totalUnits >= 6;

                                return ImprovedCartItem(
                                  title: data.name ?? 'Producto',
                                  subtitle: data.brand?.name ?? '',
                                  variantInfo: variantInfo.isNotEmpty
                                      ? variantInfo
                                      : null,
                                  imageUrl: data.img,
                                  price: data.pricing?.salePrice?.toDouble() ??
                                      0.0,
                                  costPrice:
                                      data.pricing?.commission?.toDouble() ??
                                          0.0,
                                  wholesaleCostPrice: data
                                      .pricing?.wholesaleCommission
                                      ?.toDouble(),
                                  isWholesale: isWholesale,
                                  quantity: data.quantity ?? 1,
                                  onRemove: () {
                                    context.read<CartBloc>().add(
                                          DeletedCartEvent(id: data.id ?? ''),
                                        );
                                  },
                                  onQuantityChanged: (newQuantity) {
                                    context.read<CartBloc>().add(
                                          CountCartEvent(
                                            id: data.id ?? '',
                                            quantity: newQuantity,
                                          ),
                                        );
                                  },
                                );
                              },
                            )
                          : Column(
                              children: [
                                const SizedBox(height: 32),
                                const FaIcon(
                                  FontAwesomeIcons.truckRampBox,
                                  size: 200,
                                  color: AppColors.primaryMain,
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child: Text(
                                    'Aún no has agregado ningún artículo al camión',
                                    textAlign: TextAlign.center,
                                    style:
                                        APTextStyle.textLG.semibold.copyWith(),
                                  ),
                                )
                              ],
                            ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Column(
                children: [
                  // Resumen de ganancias y total
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade50, Colors.green.shade100],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.green.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Colors.green.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Resumen de venta',
                              style: APTextStyle.textMD.semibold.copyWith(
                                color: Colors.green.shade700,
                              ),
                            ),
                            if (_calculateTotalUnits(state) >= 6) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Por Mayor',
                                  style: APTextStyle.textXS.semibold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Total de productos
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total productos (${state.listSale?.length ?? 0} items)',
                              style: APTextStyle.textSM.medium.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              '\$${addDotsToNumber(int.parse(double.parse(state.sumTotal).toStringAsFixed(0)))}',
                              style: APTextStyle.textLG.bold.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Envío
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  size: 18,
                                  color: double.parse(state.sumTotal) >= 100000
                                      ? Colors.green.shade700
                                      : Colors.grey[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Envío gratis mayor a 100.00 mil pesos',
                                  style: APTextStyle.textSM.medium.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              double.parse(state.sumTotal) >= 100000
                                  ? 'Gratis'
                                  : '\$15.000',
                              style: APTextStyle.textLG.bold.copyWith(
                                color: double.parse(state.sumTotal) >= 100000
                                    ? Colors.green.shade700
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),

                        // Ganancia total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  size: 18,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _calculateTotalUnits(state) >= 6
                                      ? 'Tu ganancia por mayor'
                                      : 'Tu ganancia',
                                  style: APTextStyle.textSM.semibold.copyWith(
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '\$${_calculateTotalProfit(state)}',
                              style: APTextStyle.textXL.bold.copyWith(
                                color: Colors.green.shade700,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     '¿Estas listo para pagar?',
                  //     style: APTextStyle.textLG.semibold.copyWith(
                  //       color: AppColors.primaryMain,
                  //       fontSize: 20,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: MediaQuery.of(context).size.height / 64),
                  AppButton.primary(
                    onPressed:
                        state.listSale != null && state.listSale!.isNotEmpty
                            ? () {
                                // Calcular el total de artículos y precio (incluyendo envío)
                                final totalItems = state.listSale!.length;
                                final totalPrice = _calculateFinalTotal(state);

                                // Navegar a la selección de direcciones
                                context.push(
                                  RoutesNames.addressSelection,
                                  extra: {
                                    'totalItems': totalItems,
                                    'totalPriceCop': totalPrice,
                                  },
                                );
                              }
                            : null,
                    title: 'Proceso de pago',
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

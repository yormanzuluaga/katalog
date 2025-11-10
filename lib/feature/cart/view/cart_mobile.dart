import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/cart/bloc/cart/cart_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class CartMobile extends StatefulWidget {
  const CartMobile({super.key});

  @override
  CartMobileState createState() => CartMobileState();
}

class CartMobileState extends State<CartMobile> with SingleTickerProviderStateMixin {
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
                    Text(
                      'Venta en curso',
                      style: APTextStyle.textXS.bold.copyWith(
                        color: AppColors.primaryMain,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      state.listSale != null && state.listSale!.isNotEmpty
                          ? 'Productos: ${state.listSale!.length}'
                          : 'No hay productos',
                      style: APTextStyle.textSM.medium.copyWith(
                        color: AppColors.gray80,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16),
                    Flexible(
                      child: state.listSale != null && state.listSale!.isNotEmpty
                          ? ListView.separated(
                              padding: const EdgeInsets.all(0.0),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => SizedBox(
                                height: MediaQuery.of(context).size.height / 72,
                              ),
                              itemCount: state.listSale!.length,
                              itemBuilder: (context, index) {
                                final data = state.listSale![index];

                                // Obtener información de la variante si está disponible
                                String variantInfo = '';
                                if (data.variants != null && data.variants!.isNotEmpty) {
                                  final variant = data.variants!.first;
                                  List<String> variantDetails = [];

                                  if (variant.color?.name != null) {
                                    variantDetails.add('Color: ${variant.color!.name}');
                                  }
                                  if (variant.size != null) {
                                    variantDetails.add('Talla: ${variant.size}');
                                  }

                                  variantInfo = variantDetails.join(' • ');
                                } else if (data.id != null && data.id!.contains('color_')) {
                                  // Si no hay variantes explícitas, extraer del ID
                                  final idParts = data.id!.split('_');
                                  for (int i = 0; i < idParts.length; i++) {
                                    if (idParts[i] == 'color' && i + 1 < idParts.length) {
                                      variantInfo = 'Color: ${idParts[i + 1].replaceAll('_', ' ')}';
                                      break;
                                    }
                                  }
                                }

                                return AppCardProduct.cardHorizontal(
                                  title: data.name ?? 'Producto',
                                  subTitle: data.brand?.name ?? '',
                                  price: '${data.pricing?.salePrice ?? '0'}',
                                  subSales: variantInfo.isNotEmpty ? variantInfo : null,
                                  sale: '${data.pricing?.costPrice ?? '0'}',
                                  height: MediaQuery.of(context).size.height / 9,
                                  subWidth: MediaQuery.of(context).size.width / 4,
                                  width: MediaQuery.of(context).size.height / 10,
                                  quantity: data.quantity ?? 1,
                                  onClosed: () {
                                    context.read<CartBloc>().add(
                                          DeletedCartEvent(id: data.id ?? ''),
                                        );
                                  },
                                  onChange: (value) {},
                                  widgetCounter: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.whitePure,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.whitePure,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: data.quantity! > 1
                                                    ? () {
                                                        context.read<CartBloc>().add(
                                                              CountCartEvent(
                                                                id: data.id ?? '',
                                                                quantity: data.quantity! - 1,
                                                              ),
                                                            );
                                                      }
                                                    : null,
                                                child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 3,
                                                    ),
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: AppColors.primaryMain,
                                                      size: 27,
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: MediaQuery.of(context).size.width / 26,
                                                ),
                                                child: AppAnimatedCounter(
                                                  duration: const Duration(milliseconds: 200),
                                                  value: data.quantity ?? 1,
                                                  textStyle: APTextStyle.textXL.bold.copyWith(
                                                    color: AppColors.primaryMain,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  context.read<CartBloc>().add(
                                                        CountCartEvent(
                                                          id: data.id ?? '',
                                                          quantity: data.quantity! + 1,
                                                        ),
                                                      );
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 3,
                                                  ),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: AppColors.primaryMain,
                                                    size: 27,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Text(
                                    'Aún no has agregado ningún artículo al camión',
                                    textAlign: TextAlign.center,
                                    style: APTextStyle.textLG.semibold.copyWith(),
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
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 18),
                          child: Text(
                            'Total',
                            style: APTextStyle.textXS.semibold.copyWith(
                              color: AppColors.whitePure,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 18,
                          ),
                          child: Text(
                            '\$${addDotsToNumber(int.parse(double.parse(state.sumTotal).toStringAsFixed(0)))}',
                            style: APTextStyle.textSM.bold.copyWith(
                              color: AppColors.whitePure,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '¿Estas listo para pagar?',
                      style: APTextStyle.textLG.semibold.copyWith(
                        color: AppColors.primaryMain,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 64),
                  AppButton.primary(
                    onPressed: state.listSale != null && state.listSale!.isNotEmpty
                        ? () {
                            // Calcular el total de artículos y precio
                            final totalItems = state.listSale!.length;
                            final totalPrice = double.parse(state.sumTotal).toInt();

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

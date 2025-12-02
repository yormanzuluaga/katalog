// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/feature/cart/bloc/cart/cart_bloc.dart';
import 'package:talentpitch_test/feature/home/bloc/home_bloc.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({
    required this.child,
    super.key,
  });
  final Widget child;
  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    // Lista de rutas que requieren botón de atrás
    final routesWithBackButton = [
      RoutesNames.subCategory,
      RoutesNames.productList,
      RoutesNames.payment,
      RoutesNames.formPayment,
    ];

    // También verificar si estamos en una ruta anidada (que no sea home o las principales)
    final isNestedRoute = currentLocation != RoutesNames.home &&
        currentLocation != RoutesNames.product &&
        currentLocation != RoutesNames.cart &&
        currentLocation != RoutesNames.wallet &&
        currentLocation != RoutesNames.setting;

    final showBackButton = routesWithBackButton.contains(currentLocation) || isNestedRoute;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteTechnical,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryMain,
                ),
                onPressed: () => currentLocation != RoutesNames.productList
                    ? currentLocation != RoutesNames.subCategory
                        ? context.pop()
                        : context.go(RoutesNames.login)
                    : context.go(RoutesNames.subCategory),
              )
            : null,
        title: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Text(
              state.index == 0
                  ? 'Producto'
                  : state.index == 1
                      ? 'Mi billetera'
                      : state.index == 2
                          ? 'Venta en curso'
                          : 'Configuración',
              style: APTextStyle.textXS.bold.copyWith(
                color: AppColors.primaryMain,
                fontSize: 24,
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    FaIcon(
                      FontAwesomeIcons.headset,
                      color: AppColors.primaryMain,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Ayuda',
                      style: APTextStyle.textMD.bold.copyWith(
                        color: AppColors.primaryMain,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: AppColors.whiteTechnical,
      body: SafeArea(child: widget.child),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return BottomNavigationBar(
                backgroundColor: AppColors.whiteTechnical,
                elevation: 0,
                selectedIconTheme: const IconThemeData(color: AppColors.primaryMain),
                unselectedIconTheme: const IconThemeData(color: AppColors.secondary),
                selectedItemColor: AppColors.primaryMain,
                unselectedItemColor: AppColors.secondary,
                items: listOfStrings.asMap().entries.map((entry) {
                  final index = entry.key;
                  final label = entry.value;

                  // Mostrar badge solo en el ícono del carrito (índice 2)
                  final showBadge = index == 2 && cartState.listSale != null && cartState.listSale!.isNotEmpty;

                  return BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        FaIcon(listOfIcons[index]),
                        if (showBadge)
                          Positioned(
                            right: -8,
                            top: -8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 169, 4, 34),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  cartState.listSale!.length.toString(),
                                  style: const TextStyle(
                                    color: AppColors.whitePure,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: label,
                  );
                }).toList(),
                currentIndex: state.index,
                onTap: (index) {
                  context.read<HomeBloc>().add(Paginator(index: index));
                  switch (index) {
                    case 0:
                      context.go(RoutesNames.product);
                      break;
                    case 1:
                      context.go(RoutesNames.wallet);
                      break;
                    case 2:
                      context.go(RoutesNames.cart);
                      break;
                    case 3:
                      context.go(RoutesNames.setting);
                      break;
                  }
                },
              );
            },
          );

          // Container(
          //   margin: EdgeInsets.only(
          //     bottom: displayWidth * .02,
          //     top: displayWidth * .01,
          //     left: displayWidth * .04,
          //     right: displayWidth * .04,
          //   ),
          //   height: displayWidth * .12,
          //   decoration: BoxDecoration(
          //     color: AppColors.whitePure,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(.1),
          //         blurRadius: 15,
          //         offset: const Offset(0, 10),
          //       ),
          //     ],
          //     borderRadius: BorderRadius.circular(50),
          //   ),
          //   child: ListView.builder(
          //     itemCount: listOfStrings.length,
          //     scrollDirection: Axis.horizontal,
          //     padding: EdgeInsets.symmetric(horizontal: displayWidth * .01),
          //     itemBuilder: (context, index) => InkWell(
          //       onTap: () {
          //         context.read<HomeBloc>().add(Paginator(index: index));

          //         switch (index) {
          //           case 0:
          //             context.go(RoutesNames.product);

          //             break;
          //           case 1:
          //             context.go(RoutesNames.wallet);

          //             break;
          //           case 2:
          //             context.go(RoutesNames.cart);
          //           case 4:
          //             context.go(RoutesNames.setting);

          //             break;
          //         }
          //         HapticFeedback.lightImpact();
          //       },
          //       splashColor: Colors.transparent,
          //       highlightColor: Colors.transparent,
          //       child: Stack(
          //         children: [
          //           AnimatedContainer(
          //             duration: const Duration(seconds: 1),
          //             curve: Curves.fastLinearToSlowEaseIn,
          //             width: index == state.index ? displayWidth * .3 : displayWidth * .15,
          //             alignment: Alignment.center,
          //             child: AnimatedContainer(
          //               duration: const Duration(seconds: 1),
          //               curve: Curves.fastLinearToSlowEaseIn,
          //               height: index == state.index ? displayWidth * .1 : 0,
          //               width: index == state.index ? displayWidth * .3 : 0,
          //               decoration: BoxDecoration(
          //                 color: index == state.index ? AppColors.secondary.shade300 : Colors.transparent,
          //                 borderRadius: BorderRadius.circular(50),
          //               ),
          //             ),
          //           ),
          //           AnimatedContainer(
          //             duration: const Duration(seconds: 1),
          //             curve: Curves.fastLinearToSlowEaseIn,
          //             width: index == state.index ? displayWidth * .3 : displayWidth * .15,
          //             alignment: Alignment.center,
          //             child: Stack(
          //               children: [
          //                 Row(
          //                   children: [
          //                     AnimatedContainer(
          //                       duration: const Duration(seconds: 1),
          //                       curve: Curves.fastLinearToSlowEaseIn,
          //                       width: index == state.index ? displayWidth * .11 : 0,
          //                     ),
          //                     AnimatedOpacity(
          //                       opacity: index == state.index ? 1 : 0,
          //                       duration: const Duration(seconds: 1),
          //                       curve: Curves.fastLinearToSlowEaseIn,
          //                       child: Text(
          //                         index == state.index ? listOfStrings[index] : '',
          //                         style: TextStyle(
          //                           color: AppColors.whitePure,
          //                           fontWeight: FontWeight.w600,
          //                           fontSize: displayWidth / 30,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 Row(
          //                   children: [
          //                     AnimatedContainer(
          //                       duration: const Duration(seconds: 1),
          //                       curve: Curves.fastLinearToSlowEaseIn,
          //                       width: index == state.index ? displayWidth * .03 : 11,
          //                     ),
          //                     FaIcon(
          //                       listOfIcons[index],
          //                       color: index == state.index
          //                           ? AppColors.whitePure
          //                           : AppColors.secondary.shade300.withOpacity(0.6),
          //                     ),
          //                   ],
          //                 ),
          //                 BlocBuilder<CartBloc, CartState>(
          //                   builder: (context, statePay) {
          //                     return statePay.listSale != null && listOfIcons[2] == listOfIcons[index]
          //                         //&& index != state.index
          //                         ? Align(
          //                             alignment: Alignment.topRight,
          //                             child: Container(
          //                               width: 25,
          //                               height: 25,
          //                               decoration: const BoxDecoration(
          //                                 color: Color.fromARGB(255, 169, 4, 34),
          //                                 shape: BoxShape.circle,
          //                               ),
          //                               child: Center(
          //                                 child: Text(
          //                                   statePay.listSale!.length.toString(),
          //                                   style: TextStyle(
          //                                     color: AppColors.whitePure,
          //                                     fontWeight: FontWeight.w600,
          //                                     fontSize: displayWidth / 30,
          //                                   ),
          //                                 ),
          //                               ),
          //                             ),
          //                           )
          //                         : Container();
          //                   },
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        },
      ),
    );
  }

  List<IconData> listOfIcons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.truck,
    //  FontAwesomeIcons.shoppingBag,
    FontAwesomeIcons.cog,
  ];

  List<String> listOfStrings = [
    'Inicio',
    'Billetera',
    'Tu pedido',
    //  'catálogo',
    'Cuenta',
  ];
}

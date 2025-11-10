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
    double displayWidth = MediaQuery.of(context).size.width;
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
                onPressed: () => context.pop(),
              )
            : null,
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
          return Container(
            margin: EdgeInsets.only(
              bottom: displayWidth * .012,
              top: displayWidth * .01,
              left: displayWidth * .04,
              right: displayWidth * .04,
            ),
            height: displayWidth * .12,
            decoration: BoxDecoration(
              color: AppColors.whitePure,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: ListView.builder(
              itemCount: listOfStrings.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: displayWidth * .01),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
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
                    case 4:
                      context.go(RoutesNames.setting);

                      break;
                  }
                  HapticFeedback.lightImpact();
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == state.index ? displayWidth * .3 : displayWidth * .15,
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: index == state.index ? displayWidth * .1 : 0,
                        width: index == state.index ? displayWidth * .3 : 0,
                        decoration: BoxDecoration(
                          color: index == state.index ? AppColors.secondary.shade300 : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == state.index ? displayWidth * .3 : displayWidth * .15,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == state.index ? displayWidth * .12 : 0,
                              ),
                              AnimatedOpacity(
                                opacity: index == state.index ? 1 : 0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: Text(
                                  index == state.index ? listOfStrings[index] : '',
                                  style: TextStyle(
                                    color: AppColors.whitePure,
                                    fontWeight: FontWeight.w600,
                                    fontSize: displayWidth / 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == state.index ? displayWidth * .03 : 11,
                              ),
                              FaIcon(
                                listOfIcons[index],
                                size: displayWidth * .054,
                                color: index == state.index
                                    ? AppColors.whitePure
                                    : AppColors.secondary.shade300.withOpacity(0.6),
                              ),
                            ],
                          ),
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, statePay) {
                              return statePay.listSale != null && listOfIcons[2] == listOfIcons[index]
                                  //&& index != state.index
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 169, 4, 34),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            statePay.listSale!.length.toString(),
                                            style: TextStyle(
                                              color: AppColors.whitePure,
                                              fontWeight: FontWeight.w600,
                                              fontSize: displayWidth / 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<IconData> listOfIcons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.shoppingBag,
    FontAwesomeIcons.truck,
    FontAwesomeIcons.cog,
  ];

  List<String> listOfStrings = [
    'Inicio',
    'Billetera',
    'Producto',
    'Tu pedido',
    'settings',
  ];
}

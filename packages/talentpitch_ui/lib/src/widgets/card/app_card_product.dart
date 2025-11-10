// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class AppCardProduct extends StatelessWidget {
  AppCardProduct.cardHorizontal({
    super.key,
    this.height,
    this.subWidth,
    this.width,
    required this.title,
    required this.subTitle,
    this.subSales,
    required this.sale,
    required this.price,
    this.quantity = 1,
    this.productImage,
    this.onPressed,
    required this.onChange,
    this.unit,
    this.onClosed,
    this.onCloseds,
    this.isCounter = false,
    this.isClosed = false,
    this.onPressedClosed,
    this.widgetCounter,
  }) : _typeStyle = _TypeStyle.horizontal;

  AppCardProduct.cardVertical({
    super.key,
    this.height,
    this.subWidth,
    this.width,
    required this.title,
    required this.subTitle,
    this.subSales,
    required this.sale,
    required this.price,
    this.quantity = 1,
    this.productImage,
    this.onPressed,
    required this.onChange,
    this.unit,
    this.onClosed,
    this.onCloseds,
    this.isCounter = false,
    this.isClosed = false,
    this.onPressedClosed,
    this.widgetCounter,
  }) : _typeStyle = _TypeStyle.vertical;

  AppCardProduct.cardVerticalProduct({
    super.key,
    this.height,
    this.subWidth,
    this.width,
    required this.title,
    required this.subTitle,
    this.subSales,
    required this.sale,
    required this.price,
    this.quantity = 1,
    this.productImage,
    this.onPressed,
    required this.onChange,
    this.unit,
    this.onClosed,
    this.onCloseds,
    this.isCounter = false,
    this.isClosed = false,
    this.onPressedClosed,
    this.widgetCounter,
  }) : _typeStyle = _TypeStyle.verticalProduct;

  final _TypeStyle _typeStyle;

  final double? height;
  final double? width;
  final double? subWidth;
  final String title;
  final String? subSales;
  final String subTitle;
  final String sale;
  final String price;

  final int quantity;
  final String? productImage;
  final String? unit;
  bool isCounter;
  bool isClosed;

  final Widget? widgetCounter;

  final Function()? onPressed;
  final VoidCallback? onPressedClosed;

  final Function(int)? onChange;
  final VoidCallback? onClosed;
  final VoidCallback? onCloseds;

  @override
  Widget build(BuildContext context) {
    switch (_typeStyle) {
      case _TypeStyle.vertical:
        return _ProductVertical(
          height: height,
          width: width,
          title: title,
          subTitle: subTitle,
          sale: sale,
          price: price,
          quantity: quantity,
          onChange: onChange,
          onPressed: onPressed,
          productImage: productImage,
          unit: unit,
          isCounter: isCounter,
          onCloseds: onCloseds!,
          isClosed: isCounter,
          onPressedClosed: onPressedClosed,
          widgetCounter: widgetCounter,
        );
      case _TypeStyle.horizontal:
        return _ProductHorizontal(
          height: height,
          width: width,
          subWidth: subWidth,
          title: title,
          subSales: subSales,
          subTitle: subTitle,
          sale: sale,
          price: price,
          quantity: quantity,
          productImage: productImage,
          onChange: onChange!,
          unit: unit,
          onClosed: onClosed!,
          isCounter: isCounter,
          isClosed: isCounter,
          onPressedClosed: onPressedClosed,
          widgetCounter: widgetCounter,
        );
      case _TypeStyle.verticalProduct:
        return _ProductVerticalStore(
          height: height,
          width: width,
          title: title,
          subTitle: subTitle,
          sale: sale,
          price: price,
          quantity: quantity,
          onChange: onChange,
          onPressed: onPressed,
          productImage: productImage,
          unit: unit,
          isCounter: isCounter,
          onCloseds: onCloseds!,
          isClosed: isCounter,
          onPressedClosed: onPressedClosed,
          widgetCounter: widgetCounter,
        );
    }
  }
}

class _ProductVertical extends StatelessWidget {
  _ProductVertical({
    this.height,
    this.width,
    required this.title,
    required this.subTitle,
    required this.sale,
    required this.price,
    this.onChange,
    this.quantity = 1,
    this.productImage,
    this.onPressed,
    this.onPressedClosed,
    required this.onCloseds,
    this.unit,
    this.isCounter = false,
    this.isClosed = false,
    this.widgetCounter,
  });

  final double? height;
  final double? width;
  final String title;
  final String subTitle;
  final String sale;
  final String price;

  final int quantity;
  final String? productImage;
  final String? unit;

  bool isCounter;
  bool isClosed;

  final Widget? widgetCounter;

  final VoidCallback? onPressedClosed;
  final Function(int)? onChange;
  final Function()? onPressed;
  final VoidCallback onCloseds;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whitePure,
      ),
      child: Column(
        children: [
          Container(
            height: (height! / 2),
            width: width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: AppColors.secondary.withOpacity(0.31),
            ),
            child: Align(
              alignment: Alignment.center,
              child: FaIcon(
                FontAwesomeIcons.boxOpen,
                color: AppColors.primaryMain,
                size: MediaQuery.of(context).size.width * 0.08,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 72, top: MediaQuery.of(context).size.height / 62),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: APTextStyle.textMD.medium.copyWith(
                  color: AppColors.secondaryDark,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 72),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'compra',
                  style: APTextStyle.textMD.medium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  '\$${addDotsToNumber(int.parse(sale))}',
                  overflow: TextOverflow.ellipsis,
                  style: APTextStyle.textMD.bold.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 72),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'venta',
                  style: APTextStyle.textMD.medium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  '\$${addDotsToNumber(int.parse(price))}',
                  overflow: TextOverflow.ellipsis,
                  style: APTextStyle.textMD.bold.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 62),
          widgetCounter!,
        ],
      ),
    );
  }
}

class _ProductVerticalStore extends StatelessWidget {
  _ProductVerticalStore({
    this.height,
    this.width,
    required this.title,
    required this.subTitle,
    required this.sale,
    required this.price,
    this.onChange,
    this.quantity = 1,
    this.productImage,
    this.onPressed,
    this.onPressedClosed,
    required this.onCloseds,
    this.unit,
    this.isCounter = false,
    this.isClosed = false,
    this.widgetCounter,
  });

  final double? height;
  final double? width;
  final String title;
  final String subTitle;
  final String sale;
  final String price;

  final int quantity;
  final String? productImage;
  final String? unit;

  bool isCounter;
  bool isClosed;

  final Widget? widgetCounter;

  final VoidCallback? onPressedClosed;
  final Function(int)? onChange;
  final Function()? onPressed;
  final VoidCallback onCloseds;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whitePure,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: (height! / 2),
                width: width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: AppColors.secondary.withOpacity(0.31),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: FaIcon(
                    FontAwesomeIcons.boxOpen,
                    color: AppColors.primaryMain,
                    size: MediaQuery.of(context).size.width * 0.08,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 9,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 92),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryMain.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Dto por volumen',
                              style: APTextStyle.textXS.bold.copyWith(
                                color: AppColors.whitePure,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 72),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: APTextStyle.textMD.medium.copyWith(
                            color: AppColors.secondaryDark,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 72),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          subTitle,
                          style: APTextStyle.textMD.medium.copyWith(
                            color: AppColors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 72),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'precio: \$${addDotsToNumber(int.parse(price))}',
                            overflow: TextOverflow.ellipsis,
                            style: APTextStyle.textSM.bold.copyWith(
                              color: AppColors.secondary[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 72),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Ganancia: \$${addDotsToNumber(int.parse(sale))}',
                            overflow: TextOverflow.ellipsis,
                            style: APTextStyle.textSM.bold.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(alignment: Alignment.bottomCenter, child: widgetCounter!),
        ],
      ),
    );
  }
}

class _ProductHorizontal extends StatelessWidget {
  _ProductHorizontal({
    this.height,
    this.width,
    this.subWidth,
    required this.title,
    required this.subTitle,
    this.subSales,
    required this.sale,
    required this.price,
    this.quantity = 1,
    required this.onChange,
    this.productImage,
    this.unit,
    this.isCounter = false,
    this.isClosed = false,
    required this.onClosed,
    this.onPressedClosed,
    this.widgetCounter,
  });

  final double? height;
  final double? width;
  final double? subWidth;

  final String title;
  final String subTitle;
  final String? subSales;
  final String sale;
  final String price;
  final int quantity;
  final String? productImage;
  final String? unit;
  bool isCounter;
  bool isClosed;
  final Widget? widgetCounter;

  final Function(int) onChange;
  final VoidCallback onClosed;
  final VoidCallback? onPressedClosed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whitePure,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryMain.withOpacity(.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FractionColumnWidth(0.28),
          1: FractionColumnWidth(0.4),
          2: FractionColumnWidth(0.32),
        },
        children: [
          TableRow(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.secondary.shade300,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.boxOpen,
                    color: AppColors.whitePure,
                    size: 32,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  subTitle,
                                  style: APTextStyle.textMD.bold.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  title,
                                  style: APTextStyle.textMD.medium.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              if (subSales != null)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    subSales ?? '',
                                    style: APTextStyle.textMD.medium.copyWith(
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Precio: \$${addDotsToNumber(int.parse(double.parse(price).toStringAsFixed(0)))}',
                            overflow: TextOverflow.ellipsis,
                            style: APTextStyle.textMD.bold.copyWith(
                              color: AppColors.primaryMain,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Ganar: \$${addDotsToNumber(int.parse(double.parse(sale).toStringAsFixed(0)))}',
                            overflow: TextOverflow.ellipsis,
                            style: APTextStyle.textMD.bold.copyWith(
                              color: AppColors.primaryMain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: onClosed,
                          child: const Icon(
                            Icons.close,
                            color: AppColors.primaryMain,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    widgetCounter!,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _TypeStyle {
  vertical,
  horizontal,
  verticalProduct,
}

enum TypeButton { main, medium, mini }

String addDotsToNumber(int number) {
  String numberString = number.toString();
  String result = '';
  int count = 0;

  for (int i = numberString.length - 1; i >= 0; i--) {
    result = numberString[i] + result;
    count++;

    if (count % 3 == 0 && i != 0) {
      result = '.$result';
    }
  }

  return result;
}

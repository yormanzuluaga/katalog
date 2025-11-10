import 'package:flutter/material.dart';

class APScreenSize {
  APScreenSize._();
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
}

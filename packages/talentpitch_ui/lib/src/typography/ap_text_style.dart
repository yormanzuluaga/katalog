// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class APTextStyle {
  APTextStyle._();

  static _Input get input => _Input();

  static _Display2XL get display2XL => _Display2XL();
  static _DisplayLG get displayLG => _DisplayLG();
  static _DisplayMD get displayMD => _DisplayMD();
  static _DisplaySM get displaySM => _DisplaySM();
  static _DisplayXL get displayXL => _DisplayXL();
  static _DisplayXS get displayXS => _DisplayXS();

  static _TextXS get textXS => _TextXS();
  static _TextSM get textSM => _TextSM();
  static _TextXL get textXL => _TextXL();
  static _TextMD get textMD => _TextMD();
  static _TextLG get textLG => _TextLG();
}

class _Display2XL {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 72,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 72,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 72,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 72,
    color: AppColors.secondaryDark,
  );
}

class _DisplayXL {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 60,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 60,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 60,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 60,
    color: AppColors.secondaryDark,
  );
}

class _DisplayLG {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 48,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 48,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 48,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 48,
    color: AppColors.secondaryDark,
  );
}

class _DisplayMD {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 36,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 36,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 36,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 36,
    color: AppColors.secondaryDark,
  );
}

class _DisplaySM {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 30,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 30,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 30,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: AppColors.secondaryDark,
  );
}

class _DisplayXS {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 24,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: AppColors.secondaryDark,
  );
}

class _TextXL {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 20,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.secondaryDark,
  );
}

class _TextLG {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 18,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: AppColors.secondaryDark,
  );
}

class _TextMD {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.secondaryDark,
  );
}

class _TextSM {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.secondaryDark,
  );
}

class _TextXS {
  TextStyle regular = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 12,
    color: AppColors.secondaryDark,
  );
  TextStyle medium = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: AppColors.secondaryDark,
  );
  TextStyle semibold = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.secondaryDark,
  );
  TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: AppColors.secondaryDark,
  );
}

class _Input {
  TextStyle hint = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: AppColors.gray100,
  );

  TextStyle hintAnnotation = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 15,
    color: AppColors.gray50,
  );

  TextStyle style = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: AppColors.secondaryDark,
  );

  TextStyle styleAnnotation = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 15,
    color: AppColors.gray100,
  );

  TextStyle error = const TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: AppColors.primaryMain,
  );
}

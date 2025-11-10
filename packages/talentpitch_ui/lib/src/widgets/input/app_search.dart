import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class AppSearch extends StatelessWidget {
  const AppSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3, // controla la sombra
      shadowColor: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(16),
      child: TextFormField(
        style: const TextStyle(color: AppColors.black),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_outlined,
                color: AppColors.primaryMain,
              )),
          //enabled: false,
          isDense: true,
          fillColor: AppColors.whitePure,
          focusColor: AppColors.transparent,
          hoverColor: AppColors.transparent,
          filled: true,
          hintText: 'Buscar productos',
        ),
      ),
    );
  }
}

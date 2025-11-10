import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class AppModalError extends StatelessWidget {
  const AppModalError({required this.errorMessage, super.key});
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.primary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(errorMessage, style: UITextStyle.errors.errorMessage),
          ],
        ),
      ),
    );
  }
}

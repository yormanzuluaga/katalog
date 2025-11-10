import 'package:talentpitch_ui/talentpitch_ui.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: BaseCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        color: AppColors.grey,
        child: Row(
          children: [
            Icon(
              leadingIcon,
              size: AppSpacing.spaceUnitPlus3,
              color: AppColors.grey,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: UITextStyle.paragraphs.paragraph1SemiBold.copyWith(color: AppColors.grey),
                  ),
                  Text(
                    subtitle,
                    style: UITextStyle.captions.captionMedium.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              trailingIcon,
              size: AppSpacing.xlg,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

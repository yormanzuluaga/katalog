import 'package:flutter/material.dart';
import 'package:talentpitch_ui/talentpitch_ui.dart';

class HorizontalFilters extends StatelessWidget {
  final List<String> filters;
  final String? selectedFilter;
  final Function(String) onFilterSelected;
  final VoidCallback onFilterCleared;

  const HorizontalFilters({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onFilterCleared,
  });

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return FilterChip(
            label: Text(
              filter,
              style: APTextStyle.textSM.medium.copyWith(
                color: isSelected ? AppColors.whitePure : AppColors.primaryMain,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (isSelected) {
                // Si ya está seleccionado, limpiar el filtro
                onFilterCleared();
              } else {
                // Seleccionar el nuevo filtro
                onFilterSelected(filter);
              }
            },
            selectedColor: AppColors.primaryMain,
            backgroundColor: AppColors.whitePure,
            checkmarkColor: AppColors.whitePure,
            side: BorderSide(
              color: isSelected
                  ? AppColors.primaryMain
                  : AppColors.primaryMain.withOpacity(0.3),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            showCheckmark: true,
          );
        },
      ),
    );
  }
}

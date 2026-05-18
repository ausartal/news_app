import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = AppConstants.categories[index];
          final isSelected = category == selectedCategory;

          return ChoiceChip(
            label: Text(AppConstants.categoryLabels[category] ?? category),
            selected: isSelected,
            onSelected: (_) => onSelected(category),
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: AppConstants.categories.length,
      ),
    );
  }
}

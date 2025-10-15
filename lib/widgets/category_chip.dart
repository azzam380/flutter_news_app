import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        showCheckmark: false, // Style M3 biasanya tanpa centang
        backgroundColor: Colors.transparent, // Latar transparan
        selectedColor: AppColors.secondaryContainer, // Latar saat terpilih
        labelStyle: TextStyle(
          color: isSelected
              ? AppColors.onSecondaryContainer // Teks saat terpilih
              : AppColors.onSurfaceVariant, // Teks saat tidak
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            // Border hanya untuk yang tidak terpilih
            color: isSelected
                ? Colors.transparent
                : AppColors.onSurfaceVariant.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
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
      child: RawChip( // Menggunakan RawChip untuk kontrol yang lebih baik
        label: Text(label),
        onPressed: onTap,
        selected: isSelected,
        showCheckmark: false,
        
        // Style yang lebih modern
        selectedColor: AppColors.primaryContainer, // Latar saat terpilih
        backgroundColor: AppColors.surfaceVariant, // Latar saat tidak terpilih
        
        labelStyle: TextStyle(
          color: isSelected
              ? AppColors.onPrimaryContainer // Teks saat terpilih
              : AppColors.onSurfaceVariant, // Teks saat tidak
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
        
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Radius lebih kecil
          side: BorderSide.none, // Tanpa border
        ),
        elevation: isSelected ? 2 : 0, // Efek elevasi saat terpilih
        shadowColor: AppColors.primaryBlue.withOpacity(0.2),
      ),
    );
  }
}
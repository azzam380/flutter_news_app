import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/category_chip.dart';
import 'package:news_app/widgets/loading_shimmer.dart';

class HomeView extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    // Menghilangkan Obx terluar untuk menstabilkan GetX error
    return Scaffold(
      backgroundColor: AppColors.background, // Set background di Scaffold
      body: Container(
        decoration: BoxDecoration(
          // Gunakan gradient secara statis karena Obx dihilangkan
          gradient: AppColors.blueGradient, 
        ),
        child: Column(
          children: [
            // Custom AppBar dengan Logo (tidak lagi dibungkus Obx)
            _buildCustomAppBar(context),
            
            // Categories (tidak lagi dibungkus Obx, hanya CategoryChip yang reaktif)
            _buildCategoryChips(),

            // News List (Tetap dibungkus Obx untuk data loading/articles)
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return LoadingShimmer();
                }

                if (controller.error.isNotEmpty) {
                  return _buildErrorWidget();
                }

                if (controller.articles.isEmpty) {
                  return _buildEmptyWidget();
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshNews,
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      final article = controller.articles[index];
                      return NewsCard(
                        article: article,
                        onTap: () =>
                            Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets Bagian Atas: NAV BAR MINIMALIS DENGAN LOGO BARU ---

  Widget _buildCustomAppBar(BuildContext context) {
    // Karena Obx dihilangkan, kita gunakan warna tema Light Mode yang sudah stabil
    const Color iconColor = AppColors.onSurface;
    const Color bgColor = AppColors.primaryBlue;

    return Container(
      color: bgColor,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // KIRI: LOGO BARU (ICON & JUDUL)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.public, // Ikon dunia sebagai logo yang bagus
                  size: 28,
                  color: AppColors.surface, // Warna biru cerah
                ),
                SizedBox(width: 8),
                Text(
                  'BLUEPRINT NEWS',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            // KANAN: Ikon Profile dan Search
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.person_outline, size: 28, color: iconColor),
                  onPressed: () {
                    Get.snackbar('Login/Register', 'Navigasi ke halaman autentikasi.');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search, size: 28, color: iconColor),
                  onPressed: () => _showSearchDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    // Karena Obx dihilangkan, kita gunakan warna tema Light Mode yang sudah stabil
    const Color bgColor = AppColors.surface;

    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          // CategoryChip harus tetap di-wrap Obx karena controller.selectedCategory adalah observable
          return Obx(
            () => CategoryChip(
              label: category.capitalize ?? category,
              isSelected: controller.selectedCategory == category,
              onTap: () => controller.selectCategory(category),
            ),
          );
        },
      ),
    );
  }

  // --- Status Widgets & Search Dialog (Hanya menggunakan Get.isDarkMode jika diperlukan) ---
  
  Widget _buildErrorWidget() {
    // Karena Obx dihilangkan, kita asumsikan Light Mode, atau gunakan Theme.of(context)
    final textColor = Theme.of(Get.context!).textTheme.bodyLarge?.color;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            SizedBox(height: 16),
            Text(
              'Oops! Gagal Memuat Berita',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Silakan cek koneksi internet Anda atau coba lagi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.refreshNews,
              child: Text('Coba Lagi', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    final textColor = Theme.of(Get.context!).textTheme.bodyLarge?.color;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: 64, color: AppColors.onSurfaceVariant),
            SizedBox(height: 16),
            Text(
              'Tidak Ada Berita Tersedia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tidak ditemukan berita untuk kategori ini. Coba kategori lain.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    const Color dialogBg = AppColors.surface;
    const Color fieldBg = AppColors.surfaceVariant;
    const Color primaryColor = AppColors.primary;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: dialogBg,
        title: const Text(
          'Cari Berita',
          style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: searchController,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: 'Masukkan kata kunci...',
            hintStyle: const TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            prefixIcon: const Icon(Icons.search, color: primaryColor),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchNews(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal', style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }
}
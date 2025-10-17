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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          // Menggunakan gradient untuk latar belakang
          gradient: AppColors.blueGradient,
        ),
        child: Column(
          children: [
            // Custom AppBar
            _buildCustomAppBar(context),
            // Custom Categories dengan gradient ringan
            _buildCategoryChips(),

            // News List
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

  // --- Widgets Bagian Atas ---

  Widget _buildCustomAppBar(BuildContext context) {
    // AppBar menggunakan warna putih (surface) agar judul kontras.
    return Container(
      color: AppColors.onSecondaryContainer, // Latar belakang putih
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BluePrint News',
              style: TextStyle(
                color: AppColors.surface, // Judul menggunakan warna Primary Blue
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, size: 28, color: AppColors.surface),
              onPressed: () => _showSearchDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    // Menggunakan Container dengan BoxDecoration agar bisa memakai Gradient/Shadow
    return Container(
      height: 65, // Sedikit lebih tinggi
      decoration: BoxDecoration(
        color: AppColors.surface, // Warna latar belakang default
        // Tambahkan BoxShadow untuk efek pemisah yang lembut
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

  // --- Status Widgets (Tidak Berubah) ---

  Widget _buildErrorWidget() {
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
                color: AppColors.onBackground,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: controller.refreshNews,
              child: Text('Coba Lagi', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
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
                color: AppColors.onBackground,
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

  // --- Search Dialog (Tidak Berubah) ---

  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.surface,
        title: Text(
          'Cari Berita',
          style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Masukkan kata kunci...',
            hintStyle: TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            prefixIcon: Icon(Icons.search, color: AppColors.primary),
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
            child: Text('Batal', style: TextStyle(color: AppColors.primary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('Cari'),
          ),
        ],
      ),
    );
  }
}
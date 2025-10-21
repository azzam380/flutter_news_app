import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/loading_shimmer.dart';

// UBAH DARI GetView MENJADI StatefulWidget (untuk mengelola TextEditingController)
class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);
  
  @override
  State<SearchView> createState() => _SearchViewState();
}

// Gunakan State untuk mengelola lifecycle dan controller
class _SearchViewState extends State<SearchView> {
  // Dapatkan controller dari GetX
  final NewsController controller = Get.find<NewsController>();
  
  late TextEditingController searchController;
  final RxString currentQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    
    // Setup listener di initState
    searchController.addListener(() {
      currentQuery.value = searchController.text;
      if (searchController.text.isNotEmpty) {
        // Panggil fungsi pencarian
        controller.searchNews(searchController.text);
      } else {
        controller.clearSearch(); 
      }
    });
  }

  // KOREKSI: Gunakan dispose() bawaan StatefulWidget
  @override
  void dispose() {
    searchController.dispose();
    controller.clearSearch(); // Membersihkan hasil saat keluar
    super.dispose(); // <-- Sekarang ini BENAR
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        title: _buildSearchField(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Get.back(),
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return LoadingShimmer();
        }

        if (currentQuery.isEmpty) {
          return _buildInitialState();
        }

        if (controller.error.isNotEmpty) {
          return _buildErrorWidget();
        }

        if (controller.articles.isEmpty) {
          return _buildEmptyWidget();
        }

        // Menampilkan Hasil Pencarian
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.articles.length,
          itemBuilder: (context, index) {
            final article = controller.articles[index];
            return NewsCard(
              article: article,
              onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
            );
          },
        );
      }),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      autofocus: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        hintText: 'Search breaking news...',
        hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
        border: InputBorder.none,
        isDense: true,
      ),
      style: const TextStyle(color: AppColors.onSurface, fontSize: 18),
    );
  }
  
  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.travel_explore, size: 64, color: AppColors.onSurfaceVariant),
          const SizedBox(height: 16),
          const Text(
            'Start typing to find news.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onBackground),
          ),
          const SizedBox(height: 8),
          const Text(
            'Results will appear instantly.',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(child: Text('Error: ${controller.error}', style: TextStyle(color: AppColors.error)));
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sentiment_dissatisfied, size: 64, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 16),
            const Text(
              'No Results Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onBackground),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for different keywords.',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/category_chip.dart';
import 'package:news_app/widgets/loading_shimmer.dart';

class HomeView extends GetView<NewsController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    // Memastikan fetch dipanggil saat kembali ke Home jika list kosong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.articles.isEmpty && !controller.isLoading && controller.error.isEmpty) {
        controller.fetchTopHeadlines();
      }
    });

    return Scaffold(
      key: _scaffoldKey, // Kunci untuk membuka drawer
      backgroundColor: AppColors.background,
      drawer: _buildAppDrawer(), // Widget Drawer untuk menu samping
      
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.blueGradient, 
        ),
        child: Column(
          children: [
            // AppBar (Navbar)
            _buildCustomAppBar(context),
            
            // Category Chips (Horizontal List)
            _buildCategoryChips(),

            // News List Area
            Expanded(
              child: Obx(() { // Obx untuk data Controller (loading/articles)
                if (controller.isLoading) {
                  return LoadingShimmer();
                }

                if (controller.error.isNotEmpty) {
                  return _buildErrorWidget(context); // Melewatkan context
                }

                if (controller.articles.isEmpty) {
                  return _buildEmptyWidget(context); // Melewatkan context
                }
                
                // Hitung jumlah item yang akan ditampilkan (min(total, limit))
                final displayCount = controller.articles.length > controller.displayLimit
                    ? controller.displayLimit
                    : controller.articles.length;

                return RefreshIndicator(
                  onRefresh: controller.refreshNews,
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    // ItemCount: jumlah yang ditampilkan + 1 jika masih ada Load More
                    itemCount: displayCount + (controller.hasMoreArticles ? 1 : 0), 
                    itemBuilder: (context, index) {
                      
                      // LOGIKA LOAD MORE
                      if (index == displayCount && controller.hasMoreArticles) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.arrow_downward),
                              label: const Text('Load More Articles'),
                              onPressed: controller.loadMoreArticles,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        );
                      }
                      
                      // Tampilkan News Card
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

  // --- WIDGET DRAWER (MENU Samping) ---

  Widget _buildAppDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header Kustom
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top + 16, bottom: 16, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.back(), // Tutup drawer
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Main Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // --- NEWS CATEGORIES SECTION ---
          _buildDrawerSection('NEWS CATEGORIES'),
          _buildDrawerItem('General', Icons.dvr, onTap: () => controller.selectCategory('general')),
          _buildDrawerItem('Technology', Icons.cloud_queue, onTap: () => controller.selectCategory('technology')),
          _buildDrawerItem('Sports', Icons.sports_soccer, onTap: () => controller.selectCategory('sports')),
          _buildDrawerItem('Health', Icons.favorite_border, onTap: () => controller.selectCategory('health')),
          _buildDrawerItem('Science', Icons.science, onTap: () => controller.selectCategory('science')),
          _buildDrawerItem('Business', Icons.home_work, onTap: () => controller.selectCategory('business')),
          _buildDrawerItem('Entertainment', Icons.theater_comedy, onTap: () => controller.selectCategory('entertainment')),

          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          
          // --- REGIONAL NEWS SECTION ---
          _buildDrawerSection('REGIONAL NEWS'),
          _buildDrawerItem('Jakarta & West Java', Icons.location_on, color: AppColors.secondary),
          _buildDrawerItem('Central Java & DIY', Icons.location_on, color: AppColors.secondary),
          _buildDrawerItem('East Java & Bali', Icons.location_on, color: AppColors.secondary),
          _buildDrawerItem('North Sumatra', Icons.location_on, color: AppColors.secondary),
          _buildDrawerItem('New Kalimantan', Icons.location_on, color: AppColors.secondary, isNew: true),
          
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          
          // --- SERVICES SECTION ---
          _buildDrawerSection('SERVICES & ACCOUNT'),
          _buildDrawerItem('Live Broadcast', Icons.live_tv, color: AppColors.error),
          _buildDrawerItem('Premium Subscription', Icons.workspace_premium, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, {VoidCallback? onTap, Color? color, bool isNew = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppColors.primary,
      ),
      title: Row(
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.onSurface, fontSize: 16),
          ),
          if (isNew)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        Get.back(); // Close drawer after selection
        onTap?.call();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }

  // --- TOP NAV BAR WIDGETS ---

  Widget _buildCustomAppBar(BuildContext context) {
    // Warna untuk Navbar Biru Gelap
    const Color iconColor = AppColors.onPrimary;
    const Color textColor = AppColors.onPrimary;
    const Color bgColor = AppColors.primaryBlue;

    return Container(
      color: bgColor,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // KIRI: Ikon Menu & Logo
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, size: 28, color: AppColors.surface),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer(); // Buka Drawer
                  },
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.public,
                  size: 28,
                  color: AppColors.surface,
                ),
                const SizedBox(width: 8),
                const Text(
                  'BLUEPRINT NEWS',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            // KANAN: Ikon Notifikasi, Profile, dan Search
            Row(
              children: [
                // 1. Ikon Notifikasi (Menuju NotificationView)
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 28, color: iconColor),
                  onPressed: () {
                    Get.toNamed(Routes.NOTIFICATION); // Navigasi ke Halaman Notifikasi
                  },
                ),
                // 2. Ikon Profil/Login (Navigasi Kondisional)
                Obx(() => IconButton(
                  icon: Icon(
                    controller.isLoggedIn ? Icons.person : Icons.person_outline, 
                    size: 28, 
                    color: iconColor
                  ),
                  onPressed: () {
                    if (controller.isLoggedIn) {
                      Get.toNamed(Routes.ACCOUNT_CENTER); // Jika sudah login, ke Pusat Akun
                    } else {
                      Get.toNamed(Routes.AUTH); // Jika belum, ke Halaman Login/Register
                    }
                  },
                )),
                // 3. Ikon Search
                IconButton(
                  icon: const Icon(Icons.search, size: 28, color: iconColor),
                  onPressed: () {
                    Get.toNamed(Routes.SEARCH); // Navigasi ke Halaman Search View
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    const Color bgColor = AppColors.surface;

    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  // --- Status Widgets & Search Dialog ---
  
  // Menerima BuildContext sebagai parameter untuk Theme.of()
  Widget _buildErrorWidget(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Oops! Failed to Load News',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection or try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.refreshNews,
              child: const Text('Retry', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Menerima BuildContext sebagai parameter untuk Theme.of()
  Widget _buildEmptyWidget(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.newspaper, size: 64, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'No News Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No news found for this category. Try another.',
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
          'Search News',
          style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: searchController,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: 'Enter search keyword...',
            hintStyle: const TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: primaryColor, width: 2),
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
            child: const Text('Cancel', style: TextStyle(color: primaryColor)),
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
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
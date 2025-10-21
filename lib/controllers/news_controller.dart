// lib/controllers/news_controller.dart

import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/utils/constants.dart';

class NewsController extends GetxController {
  final NewsService _newsService = NewsService();

  // --- OBSERVABLE STATE UNTUK OTENTIKASI ---
  final _isLoggedIn = false.obs;
  final _username = 'Guest'.obs;
  
  bool get isLoggedIn => _isLoggedIn.value;
  String get username => _username.value;

  // --- METHODS OTENTIKASI BARU ---
  void loginUser(String user) {
    _username.value = user;
    _isLoggedIn.value = true;
  }

  void logoutUser() {
    _username.value = 'Guest';
    _isLoggedIn.value = false;
    Get.snackbar('Success', 'Logout successful!', snackPosition: SnackPosition.BOTTOM);
  }

  void updateUsername(String newUsername) {
    _username.value = newUsername;
    Get.snackbar('Success', 'Username updated successfully!', snackPosition: SnackPosition.BOTTOM);
  }

  // --- VARIABLES NEWS LAMA ---
  final _isLoading = false.obs;
  final _articles = <NewsArticle>[].obs;
  final _selectedCategory = 'general'.obs;
  final _error = ''.obs;

  // Getters News
  bool get isLoading => _isLoading.value;
  List<NewsArticle> get articles => _articles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;

  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }
  
  // --- FUNGSI PENCARIAN BARU ---
  
  // Fungsi utama pencarian (dipanggil dari SearchView)
  Future<void> searchNews(String query) async {
    // Implementasi Debounce (opsional tapi direkomendasikan untuk live search)
    // Untuk menghindari API call terlalu banyak
    await 300.milliseconds.delay(); 

    if (query.isEmpty) {
      clearSearch();
      return;
    }

    try {
      _isLoading.value = true;
      _error.value = '';

      // API call service di sini
      // ASUMSI: _newsService.searchNews(query: query) sudah ada
      final response = await _newsService.searchNews(query: query); 
      _articles.value = response.articles;

    } catch (e) {
      _error.value = e.toString();
      // Tidak perlu snackbar di sini, error akan ditampilkan di SearchView
    } finally {
      _isLoading.value = false;
    }
  }

  // Fungsi untuk membersihkan hasil pencarian
  void clearSearch() {
    _articles.clear();
    _error.value = '';
    _isLoading.value = false;
  }

  // --- FUNGSI LAMA ---

  Future<void> fetchTopHeadlines({String? category}) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsService.getTopHeadlines(
        category: category ?? _selectedCategory.value,
      );

      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshNews() async {
    await fetchTopHeadlines();
  }

  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
    }
  }
}
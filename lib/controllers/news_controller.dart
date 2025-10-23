import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/routes/app_pages.dart'; 

class NewsController extends GetxController {
  final NewsService _newsService = NewsService();

  // --- OBSERVABLE STATE UNTUK OTENTIKASI ---
  final _isLoggedIn = false.obs;
  final _username = 'Guest'.obs;
  
  bool get isLoggedIn => _isLoggedIn.value;
  String get username => _username.value;

  // --- METHODS OTENTIKASI ---
  void loginUser(String user) {
    _username.value = user;
    _isLoggedIn.value = true;
  }

  void logoutUser() {
    _username.value = 'Guest';
    _isLoggedIn.value = false;
    Get.snackbar('Success', 'Logout successful!', snackPosition: SnackPosition.BOTTOM);
    Get.offAllNamed(Routes.HOME); 
  }

  void updateUsername(String newUsername) {
    _username.value = newUsername;
    Get.snackbar('Success', 'Username updated successfully!', snackPosition: SnackPosition.BOTTOM);
  }

  // --- VARIABLES NEWS ---
  final _isLoading = false.obs;
  final _articles = <NewsArticle>[].obs;
  final _selectedCategory = 'general'.obs;
  final _error = ''.obs;
  
  // --- VARIABEL BARU UNTUK DISPLAY LIMIT (paging) ---
  final _displayLimit = 5.obs; // Mulai dengan 5 kartu

  // Getters News
  bool get isLoading => _isLoading.value;
  List<NewsArticle> get articles => _articles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;

  // Getter untuk batas tampilan
  int get displayLimit => _displayLimit.value;
  
  // Getter untuk mengecek apakah masih ada kartu yang tersembunyi
  bool get hasMoreArticles {
    if (_articles.isEmpty) return false;
    return _displayLimit.value < _articles.length;
  }

  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }
  
  // --- FUNGSI PAGING BARU ---
  
  void _resetLimit() {
    _displayLimit.value = 5;
  }

  void loadMoreArticles() {
    int newLimit = _displayLimit.value + 5;
    if (newLimit < _articles.length) {
      _displayLimit.value = newLimit;
    } else {
      _displayLimit.value = _articles.length; 
    }
  }

  // --- FUNGSI PENCARIAN (MODIFIED) ---
  
  Future<void> searchNews(String query) async {
    await 300.milliseconds.delay(); 

    if (query.isEmpty) {
      clearSearch();
      return;
    }

    try {
      _isLoading.value = true;
      _error.value = '';
      _resetLimit(); 

      final response = await _newsService.searchNews(query: query); 
      _articles.value = response.articles;

    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  // Fungsi untuk membersihkan hasil pencarian (MODIFIED)
  void clearSearch() {
    _articles.clear();
    _error.value = '';
    _isLoading.value = false;
    _resetLimit(); 
  }

  // --- FUNGSI UTAMA (MODIFIED) ---

  Future<void> fetchTopHeadlines({String? category}) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      _resetLimit(); 

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
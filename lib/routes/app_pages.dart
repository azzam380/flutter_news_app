import 'package:get/get.dart';
import 'package:news_app/bindings/home_binding.dart';
import 'package:news_app/views/home_view.dart';
import 'package:news_app/views/news_detail_view.dart';
import 'package:news_app/views/splash_view.dart';
import 'package:news_app/views/notification_view.dart';
import 'package:news_app/views/auth_view.dart';
import 'package:news_app/views/account_center_view.dart'; // BARU DITAMBAHKAN
import 'package:news_app/views/search_view.dart'; // BARU DITAMBAHKAN

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.SPLASH, page: () => SplashView()),
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.NEWS_DETAIL, page: () => NewsDetailView()),
    GetPage(name: _Paths.NOTIFICATION, page: () => const NotificationView()),
    GetPage(name: _Paths.AUTH, page: () => const AuthView()),
    GetPage(name: _Paths.ACCOUNT_CENTER, page: () => const AccountCenterView()), // BARU DITAMBAHKAN
    GetPage(name: _Paths.SEARCH, page: () => SearchView()), // BARU DITAMBAHKAN
  ];
}
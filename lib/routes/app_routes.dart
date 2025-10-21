// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

// Part of 'app_pages.dart'

// Part of 'app_pages.dart'

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const AUTH = _Paths.AUTH; 
  static const ACCOUNT_CENTER = _Paths.ACCOUNT_CENTER; 
  static const SEARCH = _Paths.SEARCH; // BARU DITAMBAHKAN
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const NEWS_DETAIL = '/news-detail';
  static const NOTIFICATION = '/notification';
  static const AUTH = '/auth';
  static const ACCOUNT_CENTER = '/account-center'; 
  static const SEARCH = '/search'; // BARU DITAMBAHKAN
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/utils/network_checker.dart';
import 'data/repositories/bookmarks_repository_impl.dart';
import 'data/repositories/bookmarks_repository_provider.dart';
import 'data/repositories/news_repository_impl.dart';
import 'data/repositories/news_repository_provider.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/news_api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final localStorage = LocalStorageService(preferences);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://newsapi.org/v2',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  final newsRepository = NewsRepositoryImpl(
    apiService: NewsApiService(dio),
    storageService: localStorage,
    networkChecker: NetworkChecker(Connectivity()),
  );
  final bookmarksRepository = BookmarksRepositoryImpl(localStorage);

  runApp(
    ProviderScope(
      overrides: [
        newsRepositoryProvider.overrideWithValue(newsRepository),
        bookmarksRepositoryProvider.overrideWithValue(bookmarksRepository),
      ],
      child: const NewsApp(),
    ),
  );
}

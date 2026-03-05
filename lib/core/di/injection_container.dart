import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_client.dart';
import '../data/database/database_helper.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';
import '../../config/theme/theme_cubit.dart';

// Home Feature
import '../../features/home/data/datasource/home_remote_datasource.dart';
import '../../features/home/data/repos/home_repository.dart';
import '../../features/home/presentation/controllers/top_headlines_cubit.dart';
import '../../features/home/presentation/controllers/sources_cubit.dart';
import '../../features/home/presentation/controllers/everything_cubit.dart';

// Favorites Feature
import '../../features/favorites/data/datasource/favorites_local_datasource.dart';
import '../../features/favorites/data/repos/favorites_repository.dart';
import '../../features/favorites/presentation/controllers/favorites_cubit.dart';
import '../../features/detail/presentation/controllers/bookmark_cubit.dart';

// Search Feature
import '../../features/search/data/datasource/search_remote_datasource.dart';
import '../../features/search/data/repos/search_repository.dart';
import '../../features/search/presentation/controllers/search_cubit.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // ==================== Core ====================

  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Dio Client
  getIt.registerLazySingleton<Dio>(() => createDioClient());

  // Database
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Services
  getIt.registerLazySingleton<CacheService>(() => CacheService(getIt()));

  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // ==================== Config ====================

  // Theme Cubit
  getIt.registerFactory(() => ThemeCubit(getIt()));

  // ==================== Features ====================

  // Home Feature
  // Data Sources
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt()),
  );

  // Cubits
  getIt.registerFactory(() => TopHeadlinesCubit(getIt()));
  getIt.registerFactory(() => SourcesCubit(getIt()));
  getIt.registerFactory(() => EverythingCubit(getIt()));

  // Favorites Feature
  // Data Sources
  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(getIt()),
  );

  // Cubits
  getIt.registerFactory(() => FavoritesCubit(getIt()));
  getIt.registerFactory(() => BookmarkCubit(getIt()));

  // Search Feature
  // Data Sources
  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(getIt()),
  );

  // Cubits
  getIt.registerFactory(() => SearchCubit(getIt()));
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_preview/device_preview.dart';

import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'config/theme/theme_cubit.dart';
import 'core/di/injection_container.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ThemeCubit>(),
      child: const _NewsAppView(),
    );
  }
}

class _NewsAppView extends StatelessWidget {
  const _NewsAppView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp.router(
          // App Info
          title: 'News Insight',
          debugShowCheckedModeBanner: false,

          // Theme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.themeMode,

          // Device Preview
          locale: DevicePreview.locale(context),

          // Routing
          routerConfig: AppRouter.router,
          builder: (context, child) {
            child = DevicePreview.appBuilder(context, child);

            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: child,
            );
          },
        );
      },
    );
  }
}

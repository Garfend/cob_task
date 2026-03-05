import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/detail/presentation/ui/pages/detail_page.dart';
import '../../features/favorites/presentation/ui/pages/favorites_page.dart';
import '../../features/home/data/models/article_model.dart';
import '../../features/home/presentation/ui/pages/home_page.dart';
import '../../features/search/presentation/ui/pages/search_page.dart';
import '../../features/webview/presentation/ui/pages/article_webview_page.dart';
import '../../core/widgets/main_scaffold.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String detail = '/detail';
  static const String webview = '/webview';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: HomePage());
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                name: 'favorites',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: FavoritesPage());
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                name: 'search',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: SearchPage());
                },
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '${AppRoutes.detail}/:url',
        name: 'detail',
        pageBuilder: (context, state) {
          final article = state.extra as ArticleModel?;

          if (article == null) {
            return MaterialPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('Article not found')),
              ),
            );
          }

          return MaterialPage(
            key: state.pageKey,
            child: DetailPage(article: article),
          );
        },
      ),

      GoRoute(
        path: '${AppRoutes.webview}/:url',
        name: 'webview',
        pageBuilder: (context, state) {
          final encodedUrl = state.pathParameters['url'] ?? '';
          final url = Uri.decodeComponent(encodedUrl);
          final title = state.extra as String?;

          return MaterialPage(
            key: state.pageKey,
            child: ArticleWebViewPage(url: url, title: title),
          );
        },
      ),
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

extension GoRouterExtension on BuildContext {
  void goToHome() => go(AppRoutes.home);

  void goToFavorites() => go(AppRoutes.favorites);

  void goToSearch() => go(AppRoutes.search);

  void pushToDetail(ArticleModel article) {
    final encodedUrl = Uri.encodeComponent(article.url);
    push('${AppRoutes.detail}/$encodedUrl', extra: article);
  }

  void pushToWebView(String url, {String? title}) {
    final encodedUrl = Uri.encodeComponent(url);
    push('${AppRoutes.webview}/$encodedUrl', extra: title);
  }

  void goBack() {
    if (canPop()) {
      pop();
    } else {
      go(AppRoutes.home);
    }
  }
}

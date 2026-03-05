import 'package:flutter/material.dart';

import '../../../../../config/router/app_router.dart';

class EmptyFavoritesWidget extends StatelessWidget {
  final String message;

  const EmptyFavoritesWidget({
    super.key,
    this.message = 'No favourite articles yet',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Favourite Articles',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              'Articles you favourite will appear here.\nStart exploring and bookmark your favorites!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: () {
                context.goToHome();
              },
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Explore Articles'),
            ),
          ],
        ),
      ),
    );
  }
}

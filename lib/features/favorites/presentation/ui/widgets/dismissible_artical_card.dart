import 'package:flutter/material.dart';

import '../../../../home/data/models/article_model.dart';
import '../../../../home/presentation/ui/widgets/article_card.dart';

class DismissibleArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onDismissed;

  const DismissibleArticleCard({
    super.key,
    required this.article,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(article.url),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Theme.of(context).colorScheme.error,
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.onError,
          size: 32,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Remove Article'),
            content: const Text(
              'Are you sure you want to remove this article from favorites?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Remove'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDismissed(),
      child: ArticleCard(article: article),
    );
  }
}

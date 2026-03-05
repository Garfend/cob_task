import 'package:flutter/material.dart';

import '../../../../../core/helpers/image_helper.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../core/widgets/cached_image.dart';
import '../../../../home/data/models/article_model.dart';

/// Article info section displaying source and published date
class ArticleInfoSection extends StatelessWidget {
  final ArticleModel article;

  const ArticleInfoSection({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [

          // Source Logo
          _buildSourceLogo(context),

          const SizedBox(width: 12),

          // Source Name and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Source Name
                Text(
                  article.source.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Published Date
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.timeAgo(article.publishedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceLogo(BuildContext context) {
    final sourceUrl = article.source.name;
    final logoUrl = ImageHelper.getSourceLogoUrl(sourceUrl);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: ImageHelper.getAvatarColor(sourceUrl),
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: ClipOval(
        child: CachedImage(
          imageUrl: logoUrl,
          fit: BoxFit.cover,
          errorWidget: _buildFallbackAvatar(context),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    final initial = article.source.name.isNotEmpty
        ? article.source.name[0].toUpperCase()
        : '?';

    return Center(
      child: Text(
        initial,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/helpers/image_helper.dart';
import '../../../../../core/widgets/cached_image.dart';
import '../../../data/models/source_model.dart';

/// Horizontal scrollable source circles for filtering
class SourceCircles extends StatelessWidget {
  final List<SourceModel> sources;
  final String? selectedSourceId;
  final ValueChanged<String?> onSourceSelected;

  const SourceCircles({
    super.key,
    required this.sources,
    required this.onSourceSelected,
    this.selectedSourceId,
  });

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: sources.length + 1, // +1 for "All" option
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" option
            return _SourceCircle(
              name: 'All',
              isSelected: selectedSourceId == null,
              onTap: () => onSourceSelected(null),
            );
          }

          final source = sources[index - 1];
          return _SourceCircle(
            name: source.name,
            logoUrl: ImageHelper.getSourceLogoUrl(source.url),
            isSelected: selectedSourceId == source.id,
            onTap: () => onSourceSelected(source.id),
          );
        },
      ),
    );
  }
}

/// Individual source circle
class _SourceCircle extends StatelessWidget {
  final String name;
  final String? logoUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const _SourceCircle({
    required this.name,
    this.logoUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            // Circle avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: logoUrl != null && name != 'All'
                  ? ClipOval(
                      child: CachedImage(
                        imageUrl: logoUrl!,
                        fit: BoxFit.cover,
                        errorWidget: _buildFallbackIcon(context),
                      ),
                    )
                  : _buildFallbackIcon(context),
            ),
            const SizedBox(height: 6),

            // Name
            Text(
              name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(BuildContext context) {
    return Center(
      child: Icon(
        name == 'All' ? Icons.apps : Icons.newspaper,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

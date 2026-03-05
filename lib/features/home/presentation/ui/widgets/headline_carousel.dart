import 'package:flutter/material.dart';

import '../../../data/models/article_model.dart';
import 'banner_card.dart';

class HeadlinesBanner extends StatefulWidget {
  final List<ArticleModel> articles;

  const HeadlinesBanner({super.key, required this.articles});

  @override
  State<HeadlinesBanner> createState() => _HeadlinesBannerState();
}

class _HeadlinesBannerState extends State<HeadlinesBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: widget.articles.length,
            itemBuilder: (context, index) {
              final article = widget.articles[index];
              return BannerCard(article: article);
            },
          ),
        ),
        const SizedBox(height: 8),
        // Page indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.articles.length.clamp(0, 5),
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

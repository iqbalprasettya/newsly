import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsCardShimmer extends StatelessWidget {
  const NewsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              highlightColor: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.1),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Shimmer.fromColors(
                    baseColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                    highlightColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                    child: Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Shimmer.fromColors(
                    baseColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                    highlightColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                    child: Container(
                      height: 16,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description placeholder
                  Shimmer.fromColors(
                    baseColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                    highlightColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                    child: Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Shimmer.fromColors(
                    baseColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                    highlightColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                    child: Container(
                      height: 12,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Meta placeholder
                  Shimmer.fromColors(
                    baseColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                    highlightColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                    child: Container(
                      height: 10,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingList extends StatelessWidget {
  const LoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Breaking News Slider Placeholder
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            height: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              highlightColor: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.1),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),

        // Recommendations Header
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Text(
              'Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // News Cards Shimmer
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const NewsCardShimmer(),
            childCount: 5,
          ),
        ),
      ],
    );
  }
}

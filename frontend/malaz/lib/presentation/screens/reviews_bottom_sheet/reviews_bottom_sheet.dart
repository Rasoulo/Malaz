import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:malaz/presentation/global_widgets/error_view_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/review/review_cubit.dart';
import '../../global_widgets/cards/review/review_card.dart';
import '../../global_widgets/cards/review/review_shimmer_card.dart';

class ReviewsBottomSheet extends StatefulWidget {
  final int propertyId;
  final num rating;

  const ReviewsBottomSheet({super.key, required this.propertyId, required this.rating});

  @override
  State<ReviewsBottomSheet> createState() => _ReviewsBottomSheetState();
}

class _ReviewsBottomSheetState extends State<ReviewsBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ReviewsCubit>().loadReviews(propertyId: widget.propertyId, isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ReviewsCubit>().loadReviews(propertyId: widget.propertyId);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              children: [
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2)
                    )
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      l10n.reviews_title,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.primaryDark, size: 20),
                          const SizedBox(width: 4),
                          Text(widget.rating.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ReviewsCubit, ReviewsState>(
              builder: (context, state) {
                if (state is ReviewsLoading) {
                  return _BuildReviewShimmer();
                }

                if (state is ReviewsError) {
                  return BuildErrorView(message: state.message, onRetry: () {
                    print('retried');
                    context.read<ReviewsCubit>().loadReviews(propertyId: widget.propertyId, isRefresh: true);
                  });
                }

                if (state is ReviewsLoaded) {
                  if (state.reviews.isEmpty) {
                    return _BuildEmptyState();
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: state.hasReachedMax
                        ? state.reviews.length
                        : state.reviews.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.reviews.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return ReviewCard(review: state.reviews[index]);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            l10n.reviews_empty_title,
            style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _BuildReviewShimmer extends StatelessWidget {
  const _BuildReviewShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: ListView.separated(
          itemCount: 6,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) => const ReviewShimmerCard(),
        ),
      ),
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:malaz/core/errors/failures.dart';
import '../../../domain/entities/review/review.dart';
import '../../../domain/usecases/review/get_review_use_case.dart';

// --- States ---
abstract class ReviewsState extends Equatable {
  const ReviewsState();
  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<Review> reviews;
  final bool hasReachedMax;

  const ReviewsLoaded({required this.reviews, required this.hasReachedMax});

  @override
  List<Object?> get props => [reviews, hasReachedMax];
}

class ReviewsError extends ReviewsState {
  final String message;
  const ReviewsError(this.message);
}

class ReviewsCubit extends Cubit<ReviewsState> {
  final GetReviewsUseCase getReviewsUseCase;

  String? _nextCursor;
  bool _isFetchingMore = false;
  final List<Review> _allReviews = [];

  ReviewsCubit(this.getReviewsUseCase) : super(ReviewsInitial());

  Future<void> loadReviews({required int propertyId, bool isRefresh = false}) async {
    if (_isFetchingMore) return;

    if (isRefresh) {
      _nextCursor = null;
      _allReviews.clear();
      emit(ReviewsLoading());
    } else {
      if (state is ReviewsLoaded && (state as ReviewsLoaded).hasReachedMax) return;
    }

    _isFetchingMore = true;

    final result = await getReviewsUseCase.call(
      propertyId: propertyId,
      cursor: _nextCursor,
    );

    result.fold(
          (failure) {
        _isFetchingMore = false;
        if (_allReviews.isEmpty) {
          final String? message = failure is NetworkFailure ? AppConstants.networkFailureKey : failure.message;
          emit(ReviewsError(message ?? "Unknown error"));
        }
      },
          (reviewsList) {
        _isFetchingMore = false;
        _nextCursor = reviewsList.nextCursor;
        _allReviews.addAll(reviewsList.reviews);

        emit(ReviewsLoaded(
          reviews: List.from(_allReviews),
          hasReachedMax: _nextCursor == null,
        ));
      },
    );
  }
}
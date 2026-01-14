import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/domain/usecases/review/add_review_usecase.dart';
import '../../../domain/entities/review/review.dart';
import '../../../domain/usecases/review/get_review_use_case.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();
  @override
  List<Object?> get props => [];
}

class AddReviewSuccess extends ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<Review> reviews;
  final bool hasReachedMax;

  const ReviewsLoaded({
    required this.reviews,
    this.hasReachedMax = false,
  });

}
class AddReviewLoading extends ReviewsState {}

class AddReviewError extends ReviewsState {
  final String message;
  const AddReviewError({required this.message});
  @override
  List<Object> get props => [message];
}

class ReviewsError extends ReviewsState {
  final String message;
  const ReviewsError({required this.message});
  @override
  List<Object> get props => [message];
}

class ReviewsCubit extends Cubit<ReviewsState> {
  final GetReviewsUseCase getReviewsUseCase;
  final AddReviewsUseCase addReviewUseCase;
  String? _nextCursor;
  bool _isFetching = false;

  ReviewsCubit(this.getReviewsUseCase, this.addReviewUseCase) : super(ReviewsInitial());

  Future<void> loadReviews({
    required int propertyId,
    bool isRefresh = false,
    bool loadNext = false,
  }) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      String? cursorToSend;

      if (isRefresh) {
        cursorToSend = null;
        emit(ReviewsLoading());
      } else if (loadNext) {
        cursorToSend = _nextCursor;
        if (cursorToSend == null) {
          _isFetching = false;
          return;
        }
      } else {
        if (state is! ReviewsLoaded) emit(ReviewsLoading());
        cursorToSend = null;
      }

      final result = await getReviewsUseCase.call(
        propertyId: propertyId,
        cursor: cursorToSend,
      );

      result.fold(
            (failure) {
          String keyMessage = AppConstants.unknownFailureKey;
          if (failure is NetworkFailure) {
            keyMessage = AppConstants.networkFailureKey;
          } else if (failure is ServerFailure) {
            keyMessage = failure.message ?? AppConstants.cancelledFailureKey;
          }
          emit(ReviewsError(message: keyMessage));
        },
            (reviewsList) {
          _nextCursor = reviewsList.nextCursor;

          if (loadNext && state is ReviewsLoaded) {
            final currentList = (state as ReviewsLoaded).reviews;
            emit(ReviewsLoaded(
              reviews: currentList + reviewsList.reviews,
              hasReachedMax: _nextCursor == null,
            ));
          } else {
            emit(ReviewsLoaded(
              reviews: reviewsList.reviews,
              hasReachedMax: _nextCursor == null,
            ));
          }
        },
      );

    } catch (e) {
      if (!isClosed) emit(const ReviewsError(message: "Unexpected Error"));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> addReview({
    required int propertyId,
    required double rating,
    required String body,
  }) async {
    print('🚀 [CUBIT LOG] محاولة إرسال تقييم جديد: $rating نجوم');

    emit(AddReviewLoading());

    final result = await addReviewUseCase.call(
      idProperty: propertyId,
      rating: rating.toString(),
      body: body,
    );

    result.fold(
          (failure) {
        print('❌ [CUBIT] فشل إضافة التقييم: ${failure.toString()}');
        emit(AddReviewError(message: _mapFailureToMessage(failure)));
      },
          (success) {
        print('✨ [CUBIT] تم إضافة التقييم بنجاح! جاري تحديث القائمة...');
        emit(AddReviewSuccess());
        loadReviews(propertyId: propertyId, isRefresh: true);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) return AppConstants.networkFailureKey;
    if (failure is ServerFailure) return failure.message ?? AppConstants.unknownFailureKey;
    return AppConstants.unknownFailureKey;
  }
}
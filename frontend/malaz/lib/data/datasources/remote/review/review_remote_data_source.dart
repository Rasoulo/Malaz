import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../../../domain/entities/review/review.dart';
import '../../../models/review/review_model.dart';

abstract class ReviewsRemoteDataSource {
  Future<ReviewsList> getReviews({required int propertyId, String? cursor});
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final NetworkService networkService;

  ReviewsRemoteDataSourceImpl({required this.networkService});

  @override
  Future<ReviewsList> getReviews(
      {required int propertyId, String? cursor}) async {
    final Map<String, dynamic> queryParams = {
      'per_page': AppConstants.numberOfReviewsEachRequest,
    };

    if (cursor != null) {
      queryParams['cursor'] = cursor;
    }

    final response = await networkService.get(
      '/reviews/properties/$propertyId/reviews',
      queryParameters: queryParams,
    );

    final List<dynamic> dataList = response.data['data'];
    final meta = response.data['meta'];

    final List<ReviewModel> reviews =
        dataList.map((json) => ReviewModel.fromJson(json)).toList();

    final String? nextCursor = meta != null ? meta['next_cursor'] : null;

    return ReviewsList(
      reviews: reviews,
      nextCursor: nextCursor,
    );
  }
}

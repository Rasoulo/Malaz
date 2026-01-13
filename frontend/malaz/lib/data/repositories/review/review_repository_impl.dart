import 'package:dartz/dartz.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/review/review.dart';
import '../../../domain/repositories/review/review_repository.dart';
import '../../datasources/remote/review/review_remote_data_source.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo; // اختياري ولكنه مفضل في المشاريع الكبيرة

  ReviewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ReviewsList>> getReviews({
    required int propertyId,
    String? cursor,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReviews = await remoteDataSource.getReviews(
          propertyId: propertyId,
          cursor: cursor,
        );
        return Right(remoteReviews);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
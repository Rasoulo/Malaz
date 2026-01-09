import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/data/datasources/remote/booking/booking_remote_data_source.dart';
import 'package:malaz/data/models/booking/booking_model.dart';
import 'package:malaz/domain/entities/booking/booking.dart';
import 'package:malaz/domain/entities/booking/booking_list.dart';
import '../../../domain/repositories/booking/booking_repository.dart';
import '../../utils/failure_mapper.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<BookingModel>>> getBookedDates(int propertyId) async {
    try {
      final response = await remoteDataSource.getBookedDates(propertyId);
      return Right(response);
    } catch(e) {
      final failure = FailureMapper.map(e);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> makeBooking(Booking booking) async {
    try {
      final response = await remoteDataSource.makeBooking(booking);
      return Right(response);
    } catch(e) {
      final failure = FailureMapper.map(e);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, BookingList>> getUserBookings(int userId) async {
    try {
      final response = await remoteDataSource.fetchAllBookings(userId);
      return Right(response);
    } catch (e) {
      final failure = FailureMapper.map(e);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateStatus(int propertyID, String status) async{
    try {
      final response = await remoteDataSource.UpdateStatus(propertyID,status);
      return Right(response);
    } catch(e) {
      final failure = FailureMapper.map(e);
      return Left(failure);
    }
  }
}
import 'package:dartz/dartz.dart';
import 'package:malaz/domain/entities/booking/booking_list.dart';
import 'package:malaz/domain/repositories/booking/booking_repository.dart';
import '../../../core/errors/failures.dart';

class GetUserBooking {
  BookingRepository repository;
  GetUserBooking(this.repository);

  Future<Either<Failure,BookingList>> call({required int userId}) async {
    return await repository.getUserBookings(userId);
  }
}
import 'package:dartz/dartz.dart';
import 'package:malaz/data/models/booking/booking_model.dart';
import '../../../core/errors/failures.dart';
import '../../entities/booking/booking.dart';
import '../../entities/booking/booking_list.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> makeBooking(Booking booking);
  Future<Either<Failure, List<BookingModel>>> getBookedDates(int propertyId);
  Future<Either<Failure, BookingList>> getUserBookings(int userId);
  Future<Either<Failure,void>> updateStatus(int propertyID,String status);
}
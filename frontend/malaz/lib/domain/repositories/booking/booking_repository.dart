import 'package:dartz/dartz.dart';
import 'package:malaz/data/models/booking_model.dart';

import '../../../core/errors/failures.dart';
import '../../entities/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> makeBooking(Booking booking);
  Future<Either<Failure, List<BookingModel>>> getBookedDates(int propertyId);
}
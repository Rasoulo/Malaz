import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/domain/repositories/booking/booking_repository.dart';

import '../../entities/booking.dart';

class MakeBookUseCase {
  final BookingRepository repository;
  MakeBookUseCase(this.repository);

  Future<Either<Failure, void>> call({required Booking booking}) async {
    return await repository.makeBooking(booking);
  }
}

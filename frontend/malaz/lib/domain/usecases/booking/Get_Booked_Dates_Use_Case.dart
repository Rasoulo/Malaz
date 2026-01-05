import 'package:dartz/dartz.dart';
import 'package:malaz/domain/repositories/booking/booking_repository.dart';

import '../../../core/errors/failures.dart';
import '../../../data/models/booking_model.dart';

class GetBookedDatesUseCase {
  BookingRepository repository;
  GetBookedDatesUseCase(this.repository);

  Future<Either<Failure, List<BookingModel>>> call({required int propertyId}) async {
    return await repository.getBookedDates(propertyId);
  }
}
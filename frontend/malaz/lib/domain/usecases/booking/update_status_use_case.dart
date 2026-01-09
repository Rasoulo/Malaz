import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/domain/repositories/booking/booking_repository.dart';

import '../../entities/booking/booking.dart';

class UpdateStatus {
  final BookingRepository repository;
  UpdateStatus(this.repository);

  Future<Either<Failure, void>> call({required int propertyId,required String status}) async {
    return await repository.updateStatus(propertyId,status);
  }
}

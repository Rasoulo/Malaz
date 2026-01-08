import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/domain/entities/apartments_list.dart';

import '../../entities/filters.dart';

abstract class ApartmentRepository {
  Future<ApartmentsList> getApartments({required String? cursor, Filter? filter});
  Future<Either<Failure,Unit>> addApartment({
    required String title,
    required int price,
    required String city,
    required String governorate,
    required String address,
    required String description,
    required String type,
    required int rooms,
    required int bathrooms,
    required int bedrooms,
    required int area,
    required List <XFile> mainImageUrl,
    required XFile main_pic

  });
  Future<ApartmentsList> getMyApartments({required String? cursor});


}

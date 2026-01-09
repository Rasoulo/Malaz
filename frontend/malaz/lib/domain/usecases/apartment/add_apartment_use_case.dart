import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/errors/failures.dart';

import '../../entities/apartment/apartment.dart';
import '../../repositories/apartment/apartment_repository.dart';

class AddApartmentUseCase {
  final ApartmentRepository repository;

  AddApartmentUseCase(this.repository);

  Future<Either<Failure,Unit>> call(ApartmentParams apartment) async{
    return await repository.addApartment(
        title: apartment.title,
        price: apartment.price,
        city: apartment.city,
        governorate: apartment.governorate,
        address: apartment.address,
        description: apartment.description,
        type: apartment.type,
        rooms: apartment.rooms,
        bathrooms: apartment.bathrooms,
        bedrooms: apartment.bedrooms,
        area: apartment.area,
        mainImageUrl: apartment.mainImageUrl,
        main_pic: apartment.main_pic

    );
  }
}

class ApartmentParams {
  final String title;
  final int price;
  final String city;
  final String governorate;
  final String address;
  final String description;
  final String type;
  final int rooms;
  final int bathrooms;
  final int bedrooms;
  final int area;
  final List <XFile> mainImageUrl;
  final XFile main_pic;

  ApartmentParams({
    required this.title,
    required this.price,
    required this.city,
    required this.governorate,
    required this.address,
    required this.description,
    required this.type,
    required this.rooms,
    required this.bathrooms,
    required this.bedrooms,
    required this.area,
    required this.mainImageUrl,
    required this.main_pic
  });
}

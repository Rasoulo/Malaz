import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/errors/failures.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/entities/apartments_list.dart';
import '../../../domain/entities/filters.dart';
import '../../../domain/repositories/apartment/apartment_repository.dart';
import '../../datasources/remote/apartment/apartment_remote_data_source.dart';

class ApartmentRepositoryImpl implements ApartmentRepository {
  final ApartmentRemoteDataSource remoteDataSource;

  ApartmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApartmentsList> getApartments(
      {required String? cursor, Filter? filter}) async {
    try {
      final remoteApartments =
          await remoteDataSource.getApartments(cursor: cursor, filter: filter);
      return remoteApartments;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApartmentsList> getMyApartments({required String? cursor}) async {
    try {
      final remoteApartments =
          await remoteDataSource.getMyApartments(cursor: cursor);
      return remoteApartments;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, Unit>> addApartment(
      {required String title,
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
      required List<XFile> mainImageUrl,
      required XFile main_pic}) async {
    try {
      final resault = await remoteDataSource.addApartment(
          title: title,
          price: price,
          city: city,
          governorate: governorate,
          address: address,
          description: description,
          type: type,
          rooms: rooms,
          bathrooms: bathrooms,
          bedrooms: bedrooms,
          area: area,
          mainImageUrl: mainImageUrl,
          main_pic: main_pic);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}

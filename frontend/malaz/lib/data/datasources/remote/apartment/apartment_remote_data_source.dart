import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/domain/entities/filters/filters.dart';
import 'package:path/path.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_service.dart';
import '../../../../domain/entities/apartment/apartments_list.dart';
import '../../../models/apartment/apartment_model.dart';

abstract class ApartmentRemoteDataSource {
  Future<ApartmentsList> getApartments({String? cursor, Filter? filter});
  Future<Unit> addApartment({
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
    required XFile main_pic,
    required double latitude,
    required double longitude,
  });
  Future<ApartmentsList> getMyApartments({String? cursor});
}
class ApartmentRemoteDataSourceImpl implements ApartmentRemoteDataSource {
  final NetworkService networkService;
  ApartmentRemoteDataSourceImpl({required this.networkService});

  @override
  Future<ApartmentsList> getApartments({String? cursor, Filter? filter}) async {
    Map<String, dynamic> queryParams = {
      'per_page': AppConstants.numberOfApartmentsEachRequest,
      'cursor': cursor,
    };

    if (filter != null) {
      queryParams.addAll(filter.toMap());
    }

    queryParams.removeWhere((key, value) => value == null);
    print('queryParams ? $queryParams');

    final response = await networkService.get(
      '/properties/all',
      queryParameters: queryParams,
    );

    List<ApartmentModel> apartments = [];
    if (response.data['data'] != null) {
      print('data : ${response.data['data']}');
      apartments = List<ApartmentModel>.from(
        (response.data['data'] as List).map((e) => ApartmentModel.fromJson(e)),
      );
    } else {
      print('what happened ? ${response.data['message']}');
    }

    String? nextCursor;
    String? prevCursor;


    if (response.data['meta'] != null) {
      nextCursor = response.data['meta']['next_cursor'];
      prevCursor = response.data['meta']['prev_cursor'];
      print('in datasource nextCursor : $nextCursor');
    } else {
      print('what happened ? meta is null and ${response.data['message']}');
    }

    print('apartments : $apartments');
    return ApartmentsList(
      apartments: apartments,
      nextCursor: nextCursor,
      prevCursor: prevCursor,
    );
  }

  @override
  Future<ApartmentsList> getMyApartments({String? cursor}) async {
    print('cursor sent $cursor');
    final response = await networkService.get(
      '/properties/all/my',
      queryParameters: {
        'per_page': AppConstants.numberOfApartmentsEachRequest,
        'cursor': cursor,
      },
    );
    List<ApartmentModel> apartments = [];
    if (response.data['data'] != null) {
      print('data : ${response.data['data']}');
      apartments = List<ApartmentModel>.from(
        (response.data['data'] as List).map((e) => ApartmentModel.fromJson(e)),
      );
    } else {
      print('what happened ? ${response.data['message']}');
    }

    String? nextCursor;
    String? prevCursor;


    if (response.data['meta'] != null) {
      nextCursor = response.data['meta']['next_cursor'];
      prevCursor = response.data['meta']['prev_cursor'];
      print('in datasource nextCursor : $nextCursor');
    } else {
      print('what happened ? meta is null and ${response.data['message']}');
    }


    print('apartments : $apartments');
    return ApartmentsList(
      apartments: apartments,
      nextCursor: nextCursor,
      prevCursor: prevCursor,
    );
  }


  @override
  Future<Unit> addApartment({
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
    required List<XFile> mainImageUrl,
    required XFile main_pic,
    required double latitude,
    required double longitude
  })async {
    final endpoint='/properties';

    try{
      final formData=FormData.fromMap({
        'title': title,
        'price': price,
        'city': city,
        'governorate': governorate,
        'address': address,
        'description': description,
        'type': type,
        'number_of_rooms': rooms,
        'number_of_baths': bathrooms,
        'number_of_bedrooms': bedrooms,
        'area': area,
        'images[]': await Future.wait(
          mainImageUrl.map((image) async {
            return await MultipartFile.fromFile(
              image.path,
              filename: basename(image.path),
            );
          }).toList(),
        ),
        "main_pic": await MultipartFile.fromFile(
          main_pic.path,
          filename:main_pic.path,
        ),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      });
      final response = await networkService.post(
        endpoint,
        data: formData,
      );

      if (response.data['status'] == 200 || response.data['status'] == "success") {
        return unit;
      } else {
        throw ServerException(message: response.data['message']);
      }
    }
    catch (e, stack) {
      print('ADD PROPERTY ERROR: $e');
      print(stack);
      rethrow;}
  }
}
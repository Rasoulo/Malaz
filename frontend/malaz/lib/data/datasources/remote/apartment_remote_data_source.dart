import '../../../../core/network/network_service.dart';
import '../../../domain/entities/apartments_list.dart';
import '../../models/apartment_model.dart';

abstract class ApartmentRemoteDataSource {
  Future<ApartmentsList> getApartments({String cursor});
}

class ApartmentRemoteDataSourceImpl implements ApartmentRemoteDataSource {
  final NetworkService networkService;
  String? cursor; /// this is for next page of apartment backend need this
  /// cursor for endless scrolling

  ApartmentRemoteDataSourceImpl({required this.networkService});

  @override
  Future<ApartmentsList> getApartments({String? cursor}) async {
    final response = await networkService.get(
      '/properties/all',
      queryParameters: {
        'per_page': 10,
        'cursor': cursor,
      },
    );

    List<ApartmentModel> apartments = [];
    if (response.data['data'] != null) {
      apartments = List<ApartmentModel>.from(
        (response.data['data'] as List).map((e) => ApartmentModel.fromJson(e)),
      );
    }

    String? nextCursor;
    String? prevCursor;

    if (response.data['meta'] != null) {
      nextCursor = response.data['meta']['next_cursor'];
      prevCursor = response.data['meta']['prev_cursor'];
    }

    return ApartmentsList(
      apartments: apartments,
      nextCursor: nextCursor,
      prevCursor: prevCursor,
    );
  }
}
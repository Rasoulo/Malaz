import 'package:malaz/core/constants/app_constants.dart';

import '../../../../core/network/network_service.dart';
import '../../../domain/entities/apartments_list.dart';
import '../../models/apartment_model.dart';

abstract class ApartmentRemoteDataSource {
  Future<ApartmentsList> getApartments({String? cursor});
}

class ApartmentRemoteDataSourceImpl implements ApartmentRemoteDataSource {
  final NetworkService networkService;

  ApartmentRemoteDataSourceImpl({required this.networkService});

  @override
  Future<ApartmentsList> getApartments({String? cursor}) async {
    print('cursor sent $cursor');
    final response = await networkService.get(
      '/properties/all',
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
}
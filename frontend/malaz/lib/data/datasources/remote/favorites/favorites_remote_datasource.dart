import 'package:malaz/core/network/network_service.dart';

import '../../../models/apartment_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<ApartmentModel>> getFavorites();
  Future<void> addFavorite(int apartmentId);
  Future<void> delFavorite(int apartmentId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final NetworkService networkService;

  FavoritesRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<ApartmentModel>> getFavorites() async {
    final response = await networkService.get('/users/favorites');
    if(response.data['favorite'] == null) {
      return [];
    }
    return (response.data['favorite'] as List)
        .map((e) => ApartmentModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> addFavorite(int apartmentId) async {
    await networkService.post('/users/favorites/$apartmentId');
  }

  @override
  Future<void> delFavorite(int apartmentId) async {
    await networkService.delete('/users/favorites/$apartmentId');
  }
}
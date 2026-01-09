import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:malaz/domain/usecases/favorites/delete_favorites_use_case.dart';

import '../../../domain/entities/apartment/apartment.dart';
import '../../../domain/usecases/favorites/add_favorites_use_case.dart';
import '../../../domain/usecases/favorites/get_favorites_use_case.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}
class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Apartment> favorites;
  final int lastUpdated;

  const FavoritesLoaded(this.favorites, this.lastUpdated);

  @override
  List<Object> get props => [favorites, lastUpdated];
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;
  final DeleteFavoriteUseCase deleteFavoriteUseCase;


  List<Apartment> _currentFavorites = [];

  FavoritesCubit({
    required this.getFavoritesUseCase,
    required this.addFavoriteUseCase,
    required this.deleteFavoriteUseCase,
  }) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    if (_currentFavorites.isEmpty) emit(FavoritesLoading());

    final result = await getFavoritesUseCase.call();

    result.fold(
          (failure) => emit(FavoritesError(failure.message!)),
          (apartments) {
        _currentFavorites = apartments;
        _emitLoaded();
      },
    );
  }

  Future<void> toggleFavorite(Apartment apartment) async {
    final isFav = isFavorite(apartment.id);

    if (isFav) {
      _currentFavorites.removeWhere((element) => element.id == apartment.id);
    } else {
      _currentFavorites.add(apartment);
    }
    _emitLoaded();

    final result = isFav
        ? await deleteFavoriteUseCase.call(apartment.id)
        : await addFavoriteUseCase.call(apartment.id);

    result.fold(
          (failure) {
        if (isFav) {
          _currentFavorites.add(apartment);
        } else {
          _currentFavorites.removeWhere((element) => element.id == apartment.id); // نحذفها
        }
        emit(FavoritesError(failure.message!));
        _emitLoaded();
      },
          (_) {
      },
    );
  }

  bool isFavorite(int id) {
    return _currentFavorites.any((element) => element.id == id);
  }

  void _emitLoaded() {
    emit(FavoritesLoaded(
      List.from(_currentFavorites),
      DateTime.now().millisecondsSinceEpoch,
    ));
  }
}
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/location/location_entity.dart';
import '../../../domain/usecases/location/get_current_location_usecase.dart';
import '../../../domain/usecases/location/load_saved_location_usecase.dart';

import '../../../domain/usecases/location/update_manual_location_usecase.dart';

/// ===========================
/// ----------[states]---------
/// ===========================

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}
class LocationLoading extends LocationState {}
class LocationLoaded extends LocationState {
  final LocationEntity location;
  LocationLoaded(this.location);
  @override
  List<Object?> get props => [location];
}
class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

/// ===========================
/// ----------[cubit]----------
/// ===========================
class LocationCubit extends Cubit<LocationState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final LoadSavedLocationUseCase loadSavedLocationUseCase;
  final UpdateManualLocationUseCase updateManualLocationUseCase;

  LocationCubit({
    required this.getCurrentLocationUseCase,
    required this.loadSavedLocationUseCase,
    required this.updateManualLocationUseCase,
  }) : super(LocationInitial());

  Future<void> getCurrentLocation(String lang) async {
    emit(LocationLoading());
    try {
      final loc = await getCurrentLocationUseCase(lang);
      emit(LocationLoaded(loc));
    } catch (e) { emit(LocationError(e.toString())); }
  }

  Future<void> loadSavedLocation() async {
    final loc = await loadSavedLocationUseCase();
    if (loc != null) emit(LocationLoaded(loc));
  }

  void clearLocation() {
    emit(LocationInitial());
  }
}
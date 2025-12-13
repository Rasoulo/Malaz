import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/apartment.dart';
import '../../../../domain/usecases/apartments_use_case.dart';

/// ===========================
/// ----------[states]---------
/// ===========================

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Apartment> apartments;
  final bool hasReachedMax;
  final bool hasReachedStart;

  const HomeLoaded({
    required this.apartments,
    this.hasReachedMax = false,
    this.hasReachedStart = true,
  });

  @override
  List<Object?> get props => [apartments, hasReachedMax, hasReachedStart];

  HomeLoaded copyWith({
    List<Apartment>? apartments,
    bool? hasReachedMax,
    bool? hasReachedStart,
  }) {
    return HomeLoaded(
      apartments: apartments ?? this.apartments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      hasReachedStart: hasReachedStart ?? this.hasReachedStart,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});
  @override
  List<Object> get props => [message];
}

/// ===========================
/// ----------[cubit]----------
/// ===========================

class HomeCubit extends Cubit<HomeState> {
  final GetApartmentsUseCase getApartmentsUseCase;

  String? _nextCursor;
  String? _prevCursor;

  bool _isFetching = false;

  HomeCubit({required this.getApartmentsUseCase}) : super(HomeInitial());

  Future<void> loadApartments({
    bool isRefresh = false,
    bool loadNext = false,
    bool loadPrev = false,
  }) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      String? cursorToSend;

      if (isRefresh) {
        cursorToSend = null;
        emit(HomeLoading());
      } else if (loadNext) {
        cursorToSend = _nextCursor;
        if (cursorToSend == null) {
          _isFetching = false;
          return;
        }
      } else if (loadPrev) {
        cursorToSend = _prevCursor;
        if (cursorToSend == null) {
          _isFetching = false;
          return;
        }
      } else {
        if (state is! HomeLoaded) emit(HomeLoading());
        cursorToSend = null;
      }

      final result = await getApartmentsUseCase.call(cursor: cursorToSend);

      _nextCursor = result.nextCursor;
      _prevCursor = result.prevCursor;

      if (loadNext && state is HomeLoaded) {
        final currentList = (state as HomeLoaded).apartments;
        emit(HomeLoaded(
          apartments: currentList + result.apartments,
          hasReachedMax: _nextCursor == null,
          hasReachedStart: _prevCursor == null,
        ));
      } else {
        emit(HomeLoaded(
          apartments: result.apartments,
          hasReachedMax: _nextCursor == null,
          hasReachedStart: _prevCursor == null,
        ));
      }

    } catch (e) {
      emit(HomeError(message: 'حدث خطأ: ${e.toString()}')); /// TODO : translate
    } finally {
      _isFetching = false;
    }
  }
}
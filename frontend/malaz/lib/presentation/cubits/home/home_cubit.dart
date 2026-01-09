import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:malaz/domain/entities/filters/filters.dart';
import '../../../domain/entities/apartment/apartment.dart';
import '../../../core/errors/failures.dart';
import '../../../data/utils/failure_mapper.dart';
import '../../../domain/usecases/home/apartments_use_case.dart';

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
  Filter? _currentFilter;

  bool _isFetching = false;

  HomeCubit({required this.getApartmentsUseCase}) : super(HomeInitial());

  Future<void> loadApartments({
    bool isRefresh = false,
    bool loadNext = false,
    Filter? newFilter
  }) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      if(newFilter != null) {
        /// TODO: optimizing exists when currentFilter == newFilter
        _currentFilter = newFilter;
        isRefresh = true;
      }
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
      } else {
        if (state is! HomeLoaded) emit(HomeLoading());
        cursorToSend = null;
      }
      final result = await getApartmentsUseCase.call(cursor: cursorToSend, filter: _currentFilter);

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
      final Failure failure = FailureMapper.map(e);

      String keyMessage;

      if (failure is NetworkFailure) {
        keyMessage = AppConstants.networkFailureKey;
      } else if(failure is ServerFailure) {
        keyMessage = failure.message ?? AppConstants.cancelledFailureKey;
      } else {
        keyMessage = AppConstants.unknownFailureKey;
      }

      if (!isClosed) emit(HomeError(message: keyMessage));
    } finally {
      _isFetching = false;
    }
  }

  void clearFilter() {
    _currentFilter = null;
    loadApartments(isRefresh: true);
  }
}
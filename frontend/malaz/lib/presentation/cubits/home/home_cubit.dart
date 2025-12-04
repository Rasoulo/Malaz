import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/domain/entities/apartment.dart';
import 'package:malaz/domain/usecases/get_apartments_usecase.dart';

// --- States --- //

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Apartment> apartments;

  const HomeLoaded({required this.apartments});

  @override
  List<Object> get props => [apartments];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}

// --- Cubit --- //

class HomeCubit extends Cubit<HomeState> {
  final GetApartmentsUseCase getApartmentsUseCase;

  HomeCubit({required this.getApartmentsUseCase}) : super(HomeInitial());

  Future<void> fetchApartments() async {
    try {
      emit(HomeLoading());
      final apartments = await getApartmentsUseCase();
      emit(HomeLoaded(apartments: apartments));
    } catch (e) {
      emit(HomeError(message: 'Failed to fetch apartments: ${e.toString()}'));
    }
  }
}

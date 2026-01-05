import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import '../../../data/utils/failure_mapper.dart';
import '../../../domain/entities/apartment.dart';
import '../../../domain/usecases/apartment/add_apartment_use_case.dart';
import '../../../domain/usecases/apartment/my_apartment_use_case.dart';
import '../../../l10n/app_localizations.dart';


abstract class ApartmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApartmentInitial extends ApartmentState {}

class AddApartmentLoading extends ApartmentState {}
class AddApartmentSuccess extends ApartmentState {
  final String message;
  AddApartmentSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}
class AddApartmentError extends ApartmentState {
  final String message;
  AddApartmentError({required this.message});
  @override
  List<Object?> get props => [message];
}

class MyApartmentsLoading extends ApartmentState {}
class MyApartmentsLoaded extends ApartmentState {
  final List<Apartment> myApartments;
  final bool hasReachedMax;

  MyApartmentsLoaded({required this.myApartments, this.hasReachedMax = false});
  @override
  List<Object?> get props => [myApartments, hasReachedMax];
}
class MyApartmentsError extends ApartmentState {
  final String message;
  MyApartmentsError({required this.message});
  @override
  List<Object?> get props => [message];
}


class AddApartmentCubit extends Cubit<ApartmentState> {
  final AddApartmentUseCase addApartmentUseCase;

  AddApartmentCubit({required this.addApartmentUseCase}) : super(ApartmentInitial());

  Future<void> submitApartment({
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
    required List<XFile> images,
    required XFile main_pic,
  }) async {
    emit(AddApartmentLoading());

    final params = ApartmentParams(
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
      mainImageUrl: images,
      main_pic: main_pic,
    );

    final result = await addApartmentUseCase.call(params);

    result.fold(
          (failure) => emit(AddApartmentError(message: _mapFailureToMessage(failure))),
          (unit) => emit(AddApartmentSuccess(message: "تم رفع العقار بنجاح، وهو الآن قيد المراجعة.")),
    );
  }

  void resetState() => emit(ApartmentInitial());

  String _mapFailureToMessage(Failure f) {
    if (f is ServerFailure) return f.message ?? "خطأ من السيرفر";
    if (f is NetworkFailure) return "network falure";
    return "unexpected error";
  }
}


class MyApartmentsCubit extends Cubit<ApartmentState> {
  final GetMyApartmentsUseCase getMyApartmentsUseCase;

  String? _nextCursor;
  bool _isFetching = false;

  MyApartmentsCubit({required this.getMyApartmentsUseCase})
      : super(ApartmentInitial());

  Future<void> fetchMyApartments({bool isRefresh = false}) async {
    if (_isFetching) return;
    if (!isRefresh && state is MyApartmentsLoaded &&
        (state as MyApartmentsLoaded).hasReachedMax) return;

    _isFetching = true;

    try {
      if (isRefresh) {
        _nextCursor = null;
        emit(MyApartmentsLoading());
      } else if (state is ApartmentInitial) {
        emit(MyApartmentsLoading());
      }

      final result = await getMyApartmentsUseCase.call(cursor: _nextCursor);

      List<Apartment> currentList = [];
      if (state is MyApartmentsLoaded && !isRefresh) {
        currentList = (state as MyApartmentsLoaded).myApartments;
      }

      _nextCursor = result.nextCursor;

      final bool reachedMax = _nextCursor == null || result.apartments.isEmpty;

      emit(MyApartmentsLoaded(
        myApartments: isRefresh ? result.apartments : (currentList +
            result.apartments),
        hasReachedMax: reachedMax,
      ));
    } catch (e) {
      final Failure failure = FailureMapper.map(e);
      String keyMessage = (failure is ServerFailure)
          ? (failure.message ?? AppConstants.cancelledFailureKey)
          : AppConstants.unknownFailureKey;

      if (!isClosed) emit(MyApartmentsError(message: keyMessage));
    } finally {
      _isFetching = false;
    }
  }
}
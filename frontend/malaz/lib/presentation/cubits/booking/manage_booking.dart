import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/domain/entities/booking.dart';
import '../../../domain/usecases/booking/all_booking_use_case.dart';
import '../../../domain/usecases/booking/update_status_use_case.dart';

// --- States ---
abstract class ManageBookingState extends Equatable {
  const ManageBookingState();
  @override
  List<Object?> get props => [];
}

class ManageBookingInitial extends ManageBookingState {}

class AllBookingLoading extends ManageBookingState {}
class AllBookingsLoaded extends ManageBookingState {
  final List<Booking> bookings;
  const AllBookingsLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}
class AllBookingError extends ManageBookingState {
  final String message;
  const AllBookingError(this.message);
}

class UpdateStatusLoading extends ManageBookingState {}
class UpdateStatusSuccess extends ManageBookingState {
  final String message;
  const UpdateStatusSuccess(this.message);
}
class UpdateStatusError extends ManageBookingState {
  final String message;
  const UpdateStatusError(this.message);
}

// --- Cubit ---
class ManageBookingCubit extends Cubit<ManageBookingState> {
  final GetUserBooking allBookingUseCase;
  final UpdateStatus updateStatusUseCase;

  ManageBookingCubit(this.allBookingUseCase, this.updateStatusUseCase)
      : super(ManageBookingInitial());

  Future<void> fetchAllBookings(int userId) async {
    emit(AllBookingLoading());
    final response = await allBookingUseCase(userId: userId);

    response.fold(
          (failure) => emit(AllBookingError(failure.message ?? "error")),
          (bookingList) => emit(AllBookingsLoaded(bookingList.booking)),
    );
  }

  Future<void> updateBookingStatus(int bookingId, String status, int ownerId) async {
    emit(UpdateStatusLoading());

    final response = await updateStatusUseCase.call(propertyId: bookingId, status: status);

    response.fold(
          (failure)
          {emit(UpdateStatusError(failure.message ?? "Failed to update status, please try again."));
            fetchAllBookings(ownerId);},
          (success) {
        emit(UpdateStatusSuccess("Booking $status successfully"));
        fetchAllBookings(ownerId);
      },
    );
  }
}
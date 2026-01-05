import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/domain/entities/booking.dart';
import 'package:malaz/domain/usecases/booking/Get_Booked_Dates_Use_Case.dart';
import 'package:malaz/domain/usecases/booking/make_book_use_case.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<DateTime> bookedDays;

  const BookingLoaded(this.bookedDays);

  @override
  List<Object> get props => [bookedDays];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
}

class SendingBooking extends BookingState {}

class SentBooking extends BookingState {}

class SendingBookingError extends BookingState {
  final String message;
  const SendingBookingError(this.message);
}

class BookingCubit extends Cubit<BookingState> {
  final GetBookedDatesUseCase getBookedDatesUseCase;
  final MakeBookUseCase makeBookUseCase;
  BookingCubit(this.getBookedDatesUseCase, this.makeBookUseCase)
      : super(BookingInitial());

  Future<void> loadBookedDates(int propertyId) async {
    emit(BookingLoading());
    final response = await getBookedDatesUseCase.call(propertyId: propertyId);
    response.fold(
      (failure) => emit(BookingError(failure.message!)),
      (bookedRanges) {
        List<DateTime> dates = bookedRanges
            .expand((range) => _breakToDates(range.checkIn, range.checkOut))
            .toList();
        emit(BookingLoaded(dates));
      },
    );
  }

  Future<void> makeBook(Booking booking) async {
    emit(SendingBooking());
    final response = await makeBookUseCase.call(booking: booking);

    response.fold(
            (failure) => emit(SendingBookingError(failure.message!)),
        (_) => emit(SentBooking()));
  }

  List<DateTime> _breakToDates(DateTime checkIn, DateTime checkOut) {
    DateTime counter = checkIn;
    List<DateTime> dates = [];

    while (counter.isBefore(checkOut.add(const Duration(days: 1)))) {
      dates.add(counter);
      counter = counter.add(const Duration(days: 1));
    }

    return dates;
  }
}

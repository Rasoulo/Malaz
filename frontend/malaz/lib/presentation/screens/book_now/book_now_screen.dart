import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/domain/entities/apartment/apartment.dart';
import 'package:malaz/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/utils/dialog.dart';
import '../../../domain/entities/booking/booking.dart';
import '../../cubits/booking/booking_cubit.dart';
import '../../global_widgets/buttons/custom_button.dart';

/// ============================================================================
/// [BookingBottomSheet]
/// Main Widget that manages the State (Logic & Data) only.
/// It delegates the UI rendering to specialized [_Build...] widgets.
/// TODO: there's an optimization on ensuring selected a valid range
/// ============================================================================
class BookingBottomSheet extends StatefulWidget {
  final Apartment apartment;

  const BookingBottomSheet({super.key, required this.apartment});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final DateTime _firstDay = DateTime.now();
  late final DateTime _lastDay;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _lastDay = DateTime.now().add(const Duration(days: 730));
    context.read<BookingCubit>().loadBookedDates(widget.apartment.id);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_rangeStart, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _rangeStart = selectedDay;
        _rangeEnd = null;
        _calendarFormat = CalendarFormat.month;
      });
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
  }

  void _onConfirmBooking(Apartment apartment) {
    if (_rangeStart == null || _rangeEnd == null) return;
    int nights = _rangeEnd!.difference(_rangeStart!).inDays;
    int finalTotalPrice = nights * apartment.price;
    context.read<BookingCubit>().makeBook(
      Booking(
        propertyId: apartment.id,
        checkIn: _rangeStart!,
        checkOut: _rangeEnd!,
        totalPrice: finalTotalPrice.toString()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is SendingBooking) {
          showLoadingDialog(context);
        } else if (state is SentBooking) {
          context.pop();

          showSuccessDialog(context, () {
            context.pop();
          });
        } else if (state is SendingBookingError) {
          context.pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );

          context.read<BookingCubit>().loadBookedDates(widget.apartment.id);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const _BuildDragHandle(),
            const _BuildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<BookingCubit, BookingState>(
                  buildWhen: (previous, current) {
                    return current is! SendingBooking &&
                        current is! SentBooking &&
                        current is! SendingBookingError;
                  },
                  builder: (context, state) {
                    if (state is BookingLoading) {
                      return const Center(child: _BuildShimmerCalendar());
                    }
                    if (state is BookingLoaded) {
                      return _BuildCalendar(
                        firstDay: _firstDay,
                        lastDay: _lastDay,
                        focusedDay: _focusedDay,
                        rangeStart: _rangeStart,
                        rangeEnd: _rangeEnd,
                        calendarFormat: _calendarFormat,
                        bookedDays: state.bookedDays,
                        onDaySelected: _onDaySelected,
                        onRangeSelected: _onRangeSelected,
                        onPageChanged: _onPageChanged,
                      );
                    }
                    if (state is BookingError) {
                      return const _BuildCalendarErrorView();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            _BuildBottomSummary(
              apartment: widget.apartment,
              rangeStart: _rangeStart,
              rangeEnd: _rangeEnd,
              onConfirm: _onConfirmBooking,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// [UI_BUILDING_WIDGETS]
/// Separated components for cleaner code.
/// ============================================================================

/// [_BuildDragHandle]
/// The small grey bar at the top indicating the sheet is draggable.
class _BuildDragHandle extends StatelessWidget {
  const _BuildDragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 50,
        height: 10,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

/// [_BuildHeader]
/// Contains the title "Select Dates" and the close button.
class _BuildHeader extends StatelessWidget {
  const _BuildHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }
}

/// [_BuildCalendar]
/// The core calendar widget wrapping [TableCalendar].
/// Handles styling and interaction callbacks.
class _BuildCalendar extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final CalendarFormat calendarFormat;
  final List<DateTime> bookedDays;

  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime?, DateTime?, DateTime) onRangeSelected;
  final Function(DateTime) onPageChanged;

  const _BuildCalendar({
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.rangeStart,
    required this.rangeEnd,
    required this.calendarFormat,
    required this.bookedDays,
    required this.onDaySelected,
    required this.onRangeSelected,
    required this.onPageChanged,
  });

  bool _isDayBooked(DateTime day) {
    for (DateTime bookedDate in bookedDays) {
      if (isSameDay(day, bookedDate)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TableCalendar(
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: focusedDay,
        calendarFormat: calendarFormat,
        rangeStartDay: rangeStart,
        rangeEndDay: rangeEnd,
        rangeSelectionMode: RangeSelectionMode.toggledOn,
        startingDayOfWeek: StartingDayOfWeek.saturday,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          leftChevronIcon:
              Icon(Icons.chevron_left, color: theme.colorScheme.tertiary),
          rightChevronIcon:
              Icon(Icons.chevron_right, color: theme.colorScheme.tertiary),
        ),
        calendarStyle: CalendarStyle(
          rangeHighlightColor: theme.colorScheme.tertiary.withOpacity(0.2),
          todayDecoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: theme.colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
        ),
        selectedDayPredicate: (day) => isSameDay(rangeStart, day),
        onDaySelected: onDaySelected,
        onRangeSelected: onRangeSelected,
        onPageChanged: onPageChanged,

        /// TODO: we can optimize this, due to time pressure lets lay on it :(
        enabledDayPredicate: (day) {
          if (day.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
            return false;
          }
          if (_isDayBooked(day)) return false;
          if (rangeStart == null) {
            return true;
          }
          if (rangeStart != null && rangeEnd != null) {
            return true;
          }
          if (rangeStart != null) {
            for (var booked in bookedDays) {
              if (booked.isBefore(rangeStart!)) {
                if (day.isBefore(rangeStart!) && day.isBefore(booked)) {
                  return false;
                }
              } else {
                if (day.isAfter(rangeStart!) && day.isAfter(booked)) {
                  return false;
                }
              }
            }
          }
          return true;
        },
        calendarBuilders: CalendarBuilders(
          disabledBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            );
          },
          rangeStartBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          },
          rangeEndBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// [_BuildShimmerCalendar]
/// A skeleton loading effect mimicking the actual calendar layout.
class _BuildShimmerCalendar extends StatelessWidget {
  const _BuildShimmerCalendar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[300]!;
    final highlightColor = theme.brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(radius: 15),
                  Container(
                    width: 120,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const CircleAvatar(radius: 15),

                ],
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) =>
                  Container(
                    width: 30,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
              ),
            ),

            const SizedBox(height: 10),

            Column(
              children: List.generate(5, (rowIndex) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (colIndex) =>
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                      )
                      ),
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [_BuildCalendarErrorView]
/// Displays a user-friendly error message with a retry button.
class _BuildCalendarErrorView extends StatelessWidget {

  const _BuildCalendarErrorView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,

              size: 64,
              color: theme.colorScheme.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.unexpected_error_message,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.unexpected_error_message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// [_BuildBottomSummary]
/// The footer section showing price calculation and the confirm button.
class _BuildBottomSummary extends StatelessWidget {
  final Apartment apartment;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final Function(Apartment) onConfirm;

  const _BuildBottomSummary({
    required this.apartment,
    required this.rangeStart,
    required this.rangeEnd,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    int nights = 0;
    if (rangeStart != null && rangeEnd != null) {
      nights = rangeEnd!.difference(rangeStart!).inDays;
    }
    int totalPrice = nights * apartment.price;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nights > 0
                          ? '$nights ${AppLocalizations.of(context).nights}'
                          : AppLocalizations.of(context).book_now,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${totalPrice.toStringAsFixed(0)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 150,
                  child: CustomButton(
                    text: AppLocalizations.of(context).confirm_booking,
                    onPressed: (nights > 0) ? () => onConfirm(apartment) : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

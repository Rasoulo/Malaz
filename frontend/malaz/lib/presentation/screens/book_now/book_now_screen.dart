import 'package:flutter/material.dart';
import 'package:malaz/l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/color/app_color.dart';
import '../../global_widgets/custom_button.dart';

/// ============================================================================
/// [BookingBottomSheet]
/// Main Widget that manages the State (Logic & Data) only.
/// It delegates the UI rendering to specialized [_Build...] widgets.
/// TODO: there's a bug when selected a booked day in a range
/// TODO: it's not linked with the backend yet
/// ============================================================================
class BookingBottomSheet extends StatefulWidget {
  final double pricePerNight;

  const BookingBottomSheet({super.key, required this.pricePerNight});

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

  final List<DateTime> _bookedDays = [
    DateTime.now().add(const Duration(days: 3)),
    DateTime.now().add(const Duration(days: 4)),
    DateTime.now().add(const Duration(days: 10)),
    DateTime.now().add(const Duration(days: 11)),
    DateTime.now().add(const Duration(days: 12)),
  ];

  @override
  void initState() {
    super.initState();
    _lastDay = DateTime.now().add(const Duration(days: 730));
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

  void _onConfirmBooking() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).booking_request_sent)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
              child: _BuildCalendar(
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusedDay: _focusedDay,
                rangeStart: _rangeStart,
                rangeEnd: _rangeEnd,
                calendarFormat: _calendarFormat,
                bookedDays: _bookedDays,
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                onPageChanged: _onPageChanged,
              ),
            ),
          ),

          _BuildBottomSummary(
            pricePerNight: widget.pricePerNight,
            rangeStart: _rangeStart,
            rangeEnd: _rangeEnd,
            onConfirm: _onConfirmBooking,
          ),
        ],
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
        children: [
        ],
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
          leftChevronIcon: Icon(Icons.chevron_left, color: theme.colorScheme.tertiary),
          rightChevronIcon: Icon(Icons.chevron_right, color: theme.colorScheme.tertiary),
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

        enabledDayPredicate: (day) {
          if (day.isBefore(DateTime.now().subtract(const Duration(days: 1)))) return false;
          return !_isDayBooked(day);
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
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// [_BuildBottomSummary]
/// The footer section showing price calculation and the confirm button.
class _BuildBottomSummary extends StatelessWidget {
  final double pricePerNight;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final VoidCallback onConfirm;

  const _BuildBottomSummary({
    required this.pricePerNight,
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
    double totalPrice = nights * pricePerNight;

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
                      nights > 0 ? '$nights ${AppLocalizations.of(context).nights}' : 'Select dates',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
                    onPressed: (nights > 0) ? onConfirm : null,
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
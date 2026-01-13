import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/config/color/app_color.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/booking/booking_cubit.dart';
import '../../global_widgets/glowing_key/build_glowing_key.dart';
import '../review_apartment/apartment_review_dialog.dart';

enum BookingStatus { pending, confirmed, completed, canceled, conflicted }

class BookingModel {
  final String id;
  final String title;
  final String location;
  final DateTime checkIn;
  final DateTime checkOut;
  final double price;
  final BookingStatus status;
  final String imageUrl;

  BookingModel({
    required this.id, required this.title, required this.location,
    required this.checkIn, required this.checkOut, required this.price,
    required this.status, required this.imageUrl,
  });
}

class ManageMyBookingsScreen extends StatefulWidget {
  const ManageMyBookingsScreen({super.key});

  @override
  State<ManageMyBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageMyBookingsScreen> {
  BookingStatus? _selectedFilter;
  final List<BookingModel> _mockBookings = [
    BookingModel(
      id: 'BK-001',
      title: 'Luxury Villa Malaz',
      location: 'Riyadh, Saudi Arabia',
      checkIn: DateTime(2026, 1, 15),
      checkOut: DateTime(2026, 1, 20),
      price: 2500,
      status: BookingStatus.pending,
      imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=500',
    ),

    BookingModel(
      id: 'BK-002',
      title: 'Modern Downtown Studio',
      location: 'Jeddah, Saudi Arabia',
      checkIn: DateTime(2026, 2, 10),
      checkOut: DateTime(2026, 2, 12),
      price: 850,
      status: BookingStatus.confirmed,
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500',
    ),

    BookingModel(
      id: 'BK-003',
      title: 'Ocean View Penthouse',
      location: 'Al Khobar, Saudi Arabia',
      checkIn: DateTime(2025, 12, 01),
      checkOut: DateTime(2025, 12, 05),
      price: 4200,
      status: BookingStatus.completed,
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
    ),

    BookingModel(
      id: 'BK-004',
      title: 'Desert Rose Resort',
      location: 'Al Ula, Saudi Arabia',
      checkIn: DateTime(2026, 3, 20),
      checkOut: DateTime(2026, 3, 25),
      price: 5500,
      status: BookingStatus.canceled,
      imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=500',
    ),

    BookingModel(
      id: 'BK-005',
      title: 'City Center Apartment',
      location: 'Riyadh, Saudi Arabia',
      checkIn: DateTime(2026, 4, 05),
      checkOut: DateTime(2026, 4, 07),
      price: 1200,
      status: BookingStatus.conflicted,
      imageUrl: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=500',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final filteredBookings = _selectedFilter == null
        ? _mockBookings
        : _mockBookings.where((b) => b.status == _selectedFilter).toList();


    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildPremiumAppBar(context, tr, colorScheme),

          _buildActiveFilterIndicator(tr),

          if (filteredBookings.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text("No bookings found", style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _PremiumBookingCard(
                    booking: filteredBookings[index],
                    onEdit: () => _handleEdit(context, filteredBookings[index]),
                    onCancel: () => _handleCancel(context, filteredBookings[index]),
                  ),
                  childCount: filteredBookings.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPremiumAppBar(BuildContext context, AppLocalizations tr, ColorScheme colorScheme) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 15, top: 10),
          child: PopupMenuButton<BookingStatus?>(
            initialValue: _selectedFilter,
            onSelected: (status) {
              HapticFeedback.mediumImpact();
              setState(() => _selectedFilter = status);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            itemBuilder: (context) => [
              _buildPopupItem(null, "All Bookings", Icons.all_inbox_rounded, colorScheme),
              _buildPopupItem(BookingStatus.pending, tr.status_pending, Icons.timer_outlined, colorScheme),
              _buildPopupItem(BookingStatus.confirmed, tr.status_confirmed, Icons.check_circle_outline, colorScheme),
              _buildPopupItem(BookingStatus.completed, tr.status_completed, Icons.history_edu_rounded, colorScheme),
              _buildPopupItem(BookingStatus.canceled, tr.status_canceled, Icons.block_flipped, colorScheme),
            ],
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(decoration: const BoxDecoration(gradient: AppColors.premiumGoldGradient2)),
              PositionedDirectional(
                top: -20,
                start: -40,
                child: const BuildGlowingKey(size: 180,opacity:  0.15, rotation: -0.2),
              ),

              PositionedDirectional(
                bottom: 40,
                end: -10,
                child: const BuildGlowingKey(size: 140,opacity:  0.12,rotation:  0.5),
              ),
              Positioned(
                bottom: 16,
                left: 20,
                right: 20,
                child: Text(
                  tr.my_bookings,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<BookingStatus?> _buildPopupItem(BookingStatus? status, String label, IconData icon, ColorScheme colorScheme) {
    return PopupMenuItem(
      value: status,
      child: Row(
        children: [
          Icon(icon, size: 18, color: _selectedFilter == status ? colorScheme.primary : colorScheme.onSurface),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: _selectedFilter == status ? FontWeight.bold : FontWeight.normal,
              color: _selectedFilter == status ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _handleEdit(BuildContext context, BookingModel booking) {
    context.read<BookingCubit>().loadBookedDates(int.parse(booking.id.split('-').last));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditBookingSheet(booking: booking),
    );
  }

  void _handleCancel(BuildContext context, BookingModel booking) {
    final theme = Theme.of(context);
    final tr = AppLocalizations.of(context)!;

    HapticFeedback.heavyImpact();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = Curves.bounceOut.transform(anim1.value);
        return Transform.scale(
          scale: curve,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
              backgroundColor: theme.scaffoldBackgroundColor,
              contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 55),
                    ],
                  ),
                  const SizedBox(height: 25),

                  Text(
                    tr.cancel_booking_title,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 12),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14, height: 1.6),
                      children: [
                        TextSpan(text: tr.cancel_booking_msg(booking.title)),
                        TextSpan(
                          text: "'${booking.title}'",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: Text(
                            tr.keep_stay,
                            style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Cubit
                            // context.read<BookingCubit>().cancelBooking(booking.id);
                            //_showSuccessCancellation(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.surface,
                            elevation: 8,
                            shadowColor: theme.colorScheme.onSurface.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: Text(tr.yes_cancel, style: TextStyle(fontWeight: FontWeight.w900)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveFilterIndicator(AppLocalizations tr) {
    if (_selectedFilter == null) return const SliverToBoxAdapter(child: SizedBox(height: 10));

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 5),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Text(
                    "Status: ${_getStatusLabel(_selectedFilter!, tr)}",
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _selectedFilter = null); // هذا سيعيد عرض All Bookings
              },
              child: Text(
                "Clear All", // tr.clear_all
                style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(BookingStatus status, AppLocalizations tr) {
    switch (status) {
      case BookingStatus.pending: return tr.status_pending;
      case BookingStatus.confirmed: return tr.status_confirmed;
      case BookingStatus.completed: return tr.status_completed;
      case BookingStatus.canceled: return tr.status_canceled;
      case BookingStatus.conflicted: return tr.status_conflicted;
    }
  }

}

class _EditBookingSheet extends StatefulWidget {
  final BookingModel booking;
  const _EditBookingSheet({required this.booking});

  @override
  State<_EditBookingSheet> createState() => _EditBookingSheetState();
}

class _EditBookingSheetState extends State<_EditBookingSheet> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.booking.checkIn;
    _rangeEnd = widget.booking.checkOut;
    _focusedDay = widget.booking.checkIn;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 25),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: theme.colorScheme.tertiary.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.edit_calendar_rounded, color: theme.colorScheme.tertiary),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr.modify_reservation, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  Text(tr.changing_dates_for(widget.booking.title), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              List<DateTime> booked = (state is BookingLoaded) ? state.bookedDays : [];

              return TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                startingDayOfWeek: StartingDayOfWeek.saturday,
                onRangeSelected: (start, end, focusedDay) {
                  setState(() { _rangeStart = start; _rangeEnd = end; _focusedDay = focusedDay; });
                },
                enabledDayPredicate: (day) => !booked.any((d) => isSameDay(d, day)),
                calendarStyle: CalendarStyle(
                  rangeHighlightColor: theme.colorScheme.primary.withOpacity(0.1),
                  rangeStartDecoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                  rangeEndDecoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.2), shape: BoxShape.circle),
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              );
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: (_rangeStart != null && _rangeEnd != null) ? () => Navigator.pop(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text(tr.confirm_new_dates, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const _PremiumBookingCard({required this.booking, required this.onEdit, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = AppLocalizations.of(context)!;
    final config = _getStatusConfig(booking.status, tr);

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: Image.network(booking.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 15, right: 15,
                child: _buildGlassStatus(config),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.6)]),
                  ),
                ),
              ),
              Positioned(bottom: 12, left: 20, child: Text("\$${booking.price.toInt()}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateInfo(tr.check_in, booking.checkIn, theme: theme.colorScheme),
                    Icon(Icons.swap_horiz_rounded, color: theme.primaryColor),
                    _buildDateInfo(tr.check_out, booking.checkOut, isEnd: true, theme: theme.colorScheme),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(height: 1),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGlassStatus(config),

                    if (booking.status == BookingStatus.pending)
                      Row(
                        children: [
                          _buildActionBtn(Icons.edit_calendar_rounded, tr.edit, Colors.blueAccent, onEdit),
                          const SizedBox(width: 8),
                          _buildActionBtn(Icons.close_rounded, tr.cancel, Colors.redAccent, onCancel),
                        ],
                      )
                    else if (booking.status == BookingStatus.completed)
                      _buildPremiumRateButton(context, tr, booking)
                    else
                      _buildViewDetailsBtn(context, tr)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewDetailsBtn(BuildContext context, AppLocalizations tr) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        // Navigate to details
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.05), // خلفية باهتة جداً
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr.view_details,
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: theme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumRateButton(BuildContext context, AppLocalizations tr, BookingModel booking) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showReviewDialog(context, booking);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppColors.premiumGoldGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              tr.rate_the_apartment,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => ApartmentReviewDialog(
        propertyName: booking.title,
        onSubmitted: (rating, comment) {
          print("التقييم: $rating، التعليق: $comment");
          /// TODO: REVIEW CUBIT...
        },
      ),
    );
  }

  Widget _buildGlassStatus(_StatusConfig config) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: config.color.withOpacity(0.7), borderRadius: BorderRadius.circular(12)),
          child: Text(config.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10)),
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime date, {bool isEnd = false, required ColorScheme theme}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 15, color: theme.primary, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(DateFormat('dd MMM').format(date), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12), // خلفية شفافة قليلاً
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 1), // إطار خفيف جداً
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig(BookingStatus status, AppLocalizations tr) {
    switch (status) {
      case BookingStatus.pending: return _StatusConfig(tr.status_pending, Colors.orange, Icons.schedule);
      case BookingStatus.confirmed: return _StatusConfig(tr.status_confirmed, Colors.green, Icons.verified);
      case BookingStatus.completed: return _StatusConfig(tr.status_completed, Colors.blue, Icons.task_alt);
      case BookingStatus.canceled: return _StatusConfig(tr.status_canceled, Colors.red, Icons.cancel_outlined);
      case BookingStatus.conflicted: return _StatusConfig(tr.status_conflicted, Colors.purple, Icons.warning_amber_rounded);
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;
  _StatusConfig(this.label, this.color, this.icon);
}

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

enum BookingStatus { accepted, pending, cancelled }

class BookingModel {
  final String id;
  final String title;
  final String location;
  final String date;
  final double price;
  final BookingStatus status;
  final String imageUrl;

  BookingModel({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.status,
    required this.imageUrl,
  });
}

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    final bookings = [
      BookingModel(id: 'BK-001', title: 'Modern Downtown Apartment', location: 'Downtown', date: 'Jan 15, 2024', price: 1200, status: BookingStatus.accepted, imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=200&fit=crop'),
      BookingModel(id: 'BK-002', title: 'Luxury Penthouse', location: 'Uptown', date: 'Feb 1, 2024', price: 2500, status: BookingStatus.pending, imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=200&fit=crop'),
      BookingModel(id: 'BK-003', title: 'Cozy Studio', location: 'Midtown', date: 'Dec 20, 2023', price: 900, status: BookingStatus.cancelled, imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=200&fit=crop'),
    ];

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(tr.my_bookings, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return _BookingCard(booking: bookings[index]);
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;

  const _BookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color statusColor;
    Color statusBg;
    String statusText;

    switch (booking.status) {
      case BookingStatus.accepted:
        statusColor = Colors.green.shade700;
        statusBg = Colors.green.shade50;
        statusText = 'Accepted'; // These should be translated too if needed
        break;
      case BookingStatus.pending:
        statusColor = Colors.orange.shade700;
        statusBg = Colors.orange.shade50;
        statusText = 'Pending';
        break;
      case BookingStatus.cancelled:
        statusColor = colorScheme.error;
        statusBg = colorScheme.error.withOpacity(0.1);
        statusText = 'Cancelled';
        break;
    }

    return Opacity(
      opacity: booking.status == BookingStatus.cancelled ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10)),
                    child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  Text('#${booking.id}', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(booking.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(booking.location, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Check-in: ${booking.date}', style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text('\$${booking.price.toInt()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.primary)),
                      Text('/mo', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                    ],
                  )
                ],
              ),
              if (booking.status != BookingStatus.cancelled) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_red_eye, size: 16),
                        label: const Text('Details'), // This should be translated
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat, size: 16),
                        label: const Text('Chat'), // This should be translated
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          foregroundColor: Colors.blue.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

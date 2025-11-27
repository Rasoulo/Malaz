import 'package:flutter/material.dart';
import '../../../core/config/theme/theme_config.dart';


// Enum لضمان التعامل الآمن مع الحالات
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
    required this.id, required this.title, required this.location,
    required this.date, required this.price, required this.status, required this.imageUrl
  });
}

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookings = [
      BookingModel(id: 'BK-001', title: 'Modern Downtown Apartment', location: 'Downtown', date: 'Jan 15, 2024', price: 1200, status: BookingStatus.accepted, imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=200&fit=crop'),
      BookingModel(id: 'BK-002', title: 'Luxury Penthouse', location: 'Uptown', date: 'Feb 1, 2024', price: 2500, status: BookingStatus.pending, imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=200&fit=crop'),
      BookingModel(id: 'BK-003', title: 'Cozy Studio', location: 'Midtown', date: 'Dec 20, 2023', price: 900, status: BookingStatus.cancelled, imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=200&fit=crop'),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
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

// Private Widget specialized for this screen
class _BookingCard extends StatelessWidget {
  final BookingModel booking;

  const _BookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان والنصوص بناءً على الحالة
    Color statusColor;
    Color statusBg;
    String statusText;

    switch (booking.status) {
      case BookingStatus.accepted:
        statusColor = Colors.green.shade700;
        statusBg = Colors.green.shade50;
        statusText = 'Accepted';
        break;
      case BookingStatus.pending:
        statusColor = Colors.orange.shade700;
        statusBg = Colors.orange.shade50;
        statusText = 'Pending';
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red.shade700;
        statusBg = Colors.red.shade50;
        statusText = 'Cancelled';
        break;
    }

    // تقليل الشفافية إذا كان ملغياً (كما في التصميم الأصلي)
    return Opacity(
      opacity: booking.status == BookingStatus.cancelled ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header: Status Badge & ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10)),
                    child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  Text('#${booking.id}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),

              // Content: Image & Details
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
                        Text(booking.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(booking.location, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Check-in: ${booking.date}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text('\$${booking.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                      const Text('/mo', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  )
                ],
              ),

              // Action Buttons (Only if not cancelled)
              if (booking.status != BookingStatus.cancelled) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_red_eye, size: 16),
                        label: const Text('Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat, size: 16),
                        label: const Text('Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: Colors.blue,
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
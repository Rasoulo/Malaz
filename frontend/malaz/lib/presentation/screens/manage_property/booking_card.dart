import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/booking/booking.dart';
import '../../cubits/booking/manage_booking.dart';
import '../../cubits/chat/chat_cubit.dart';
import '../../global_widgets/user_profile_image/user_profile_image.dart';
import '../../../core/config/color/app_color.dart';

class BookingCardWidget extends StatelessWidget {
  final Booking booking;
  final bool isPending;
  final int ownerId;

  const BookingCardWidget({
    super.key,
    required this.booking,
    required this.isPending,
    required this.ownerId,
  });

  @override
  Widget build(BuildContext context) {
    final String firstName = booking.user?.first_name ?? 'Guest';
    final String lastName = booking.user?.last_name ?? '';
    final String checkInStr = "${booking.checkIn!.day}/${booking.checkIn!.month}";
    final String checkOutStr = "${booking.checkOut!.day}/${booking.checkOut!.month}";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              UserProfileImage(userId: booking.userId!),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$firstName $lastName",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text("From $checkInStr to $checkOutStr",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ),
              _buildChatButton(context, firstName, lastName),
            ],
          ),
          const Divider(height: 30, thickness: 0.8),
          _buildApartmentInfo(isPending),
          if (isPending) _buildActionSection(context),
        ],
      ),
    );
  }


  Widget _buildChatButton(BuildContext context, String fName, String lName) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.chat_outlined, color: Theme.of(context).colorScheme.primary),
        onPressed: () async {
          final chatCubit = context.read<ChatCubit>();
          chatCubit.clearMessages();
          final newId = await chatCubit.saveNewConversation(booking.userId!);
          if (newId != null && context.mounted) {
            context.pushNamed('one_chat', extra: {
              'id': newId,
              'firstName': fName,
              'lastName': lName,
              'otherUserId': booking.userId,
            });
          }
        },
      ),
    );
  }

  Widget _buildApartmentInfo(bool isPending) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            booking.apartment?.mainImageUrl ?? '',
            width: 50, height: 50, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(width: 50, height: 50, color: Colors.grey[100], child: const Icon(Icons.home)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(booking.apartment?.title ?? "Property",
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text("${booking.totalPrice} \$",
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
        if (!isPending) _StatusBadge(status: booking.status!),
      ],
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showConfirmActionDialog(context, 'cancelled'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryLight.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Reject", style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _showConfirmActionDialog(context, 'confirmed'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGoldGradient2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text("Accept", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _showConfirmActionDialog(BuildContext context, String status) {
    final bool isAccept = status == 'confirmed';
    final cubit = context.read<ManageBookingCubit>();

    showDialog(
      context: context,
      builder: (confirmContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isAccept ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isAccept ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: isAccept ? Colors.green : Colors.red,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isAccept ? "Confirm Booking?" : "Reject Request?",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to change the status to $status?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(confirmContext),
                        child: const Text("Back", style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(confirmContext);
                          _showSmartResultDialog(context, cubit);
                          cubit.updateBookingStatus(booking.id!, status, ownerId);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: isAccept ? AppColors.premiumGoldGradient2 : null,
                            color: isAccept ? null : Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text("Confirm", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSmartResultDialog(BuildContext context, ManageBookingCubit cubit) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isLoading = true;
        bool? isSuccess;
        String message = "Processing your request...";

        return StatefulBuilder(
          builder: (context, setState) {
            final subscription = cubit.stream.listen((state) {
              if (state is UpdateStatusSuccess || state is UpdateStatusError) {
                if (dialogContext.mounted) {
                  setState(() {
                    isLoading = false;
                    isSuccess = state is UpdateStatusSuccess;
                    message = isSuccess!
                        ? (state as UpdateStatusSuccess).message
                        : (state as UpdateStatusError).message;
                  });
                }
              }
            });

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      const Text("Please wait...", style: TextStyle(fontWeight: FontWeight.bold)),
                    ] else ...[
                      Icon(
                        isSuccess! ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                        color: isSuccess! ? Colors.green : Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isSuccess! ? "Success" : "Notice",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSuccess! ? Colors.green : Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            subscription.cancel();
                            Navigator.pop(dialogContext);
                          },
                          child: const Text("OK", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.orange;
    if (status == 'accepted' || status == 'confirmed') color = Colors.green;
    if (status == 'canceled' || status == 'rejected' || status == 'cancelled') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2))),
      child: Text(status.toUpperCase(),
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
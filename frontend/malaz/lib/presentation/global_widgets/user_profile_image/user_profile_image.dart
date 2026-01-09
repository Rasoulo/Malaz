import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../data/datasources/local/auth/auth_local_data_source.dart';
import '../../../core/config/color/app_color.dart';

class UserProfileImage extends StatelessWidget {
  final int userId;
  final double radius;
  final String? firstName;
  final String? lastName;
  final bool isPremiumStyle;

  const UserProfileImage({
    super.key,
    required this.userId,
    this.firstName,
    this.lastName,
    this.radius = 35,
    this.isPremiumStyle = true,
  });

  Future<Map<String, String>> _getHeaders() async {
    final authLocal = sl<AuthLocalDatasource>();
    final token = await authLocal.getCachedToken();
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  String _getInitials() {
    final String f = (firstName != null && firstName!.isNotEmpty) ? firstName![0].toUpperCase() : '';
    final String l = (lastName != null && lastName!.isNotEmpty) ? lastName![0].toUpperCase() : '';
    return '$f$l';
  }

  Widget _buildInitialsPlaceholder() {
    final initials = _getInitials();
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius * 0.6), // Squircle
        gradient: AppColors.premiumGoldGradient,
      ),
      alignment: Alignment.center,
      child: initials.isEmpty
          ? Icon(Icons.person, color: Colors.white, size: radius)
          : Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius * 0.6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String url = AppConstants.userProfileImage(userId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: isPremiumStyle ? const EdgeInsets.all(2) : EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: isPremiumStyle ? AppColors.premiumGoldGradient : null,
        borderRadius: BorderRadius.circular(radius * 0.7),
      ),
      child: Container(
        padding: isPremiumStyle ? const EdgeInsets.all(2) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(radius * 0.65),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius * 0.6),
          child: FutureBuilder<Map<String, String>>(
            future: _getHeaders(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return _buildShimmerLoading(isDark);

              return Image.network(
                url,
                headers: snapshot.data,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildShimmerLoading(isDark);
                },
                errorBuilder: (context, error, stackTrace) => _buildInitialsPlaceholder(),
              );
            },
          ),
        ),
      ),
    );
  }
}
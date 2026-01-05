import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../data/datasources/local/auth_local_datasource.dart';

class UserProfileImage extends StatelessWidget {
  final int userId;
  final double radius;
  final String? firstName;
  final String? lastName;

  const UserProfileImage({
    super.key,
    required this.userId,
    this.firstName,
    this.lastName,
    this.radius = 35,
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

  Widget _buildInitialsPlaceholder(BuildContext context) {
    final initials = _getInitials();

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFE6BE6A), Color(0xFFB38B3F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: initials.isEmpty
          ? Icon(Icons.person, color: Colors.white, size: radius)
          : Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String url = AppConstants.userProfileImage(userId);

    return FutureBuilder<Map<String, String>>(
      future: _getHeaders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[200],
          );
        }

        return ClipOval(
          child: Image.network(
            url,
            headers: snapshot.data,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: radius * 2,
                height: radius * 2,
                color: Colors.grey[100],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 1),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => _buildInitialsPlaceholder(context),
          ),
        );
      },
    );
  }
}
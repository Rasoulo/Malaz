import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../data/datasources/local/auth_local_datasource.dart';

class UserProfileImage extends StatelessWidget {
  final int userId;
  final double radius;

  const UserProfileImage({super.key, required this.userId, this.radius = 25});

  Future<Map<String, String>> _getHeaders() async {
    final authLocal = sl<AuthLocalDatasource>();
    final token = await authLocal.getCachedToken();
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
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

        return Container(
          width: radius * 2,
          height: radius * 2,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: Image.network(
              url,
              headers: snapshot.data,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[100],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                      Icons.person,
                      size: radius,
                      color: Colors.grey[400]
                  ),
                );
              },
            ),
            // child: CachedNetworkImage(
            //   imageUrl: url,
            //   httpHeaders: snapshot.data,
            //   fit: BoxFit.cover,
            //   placeholder: (context, url) => Container(
            //     color: Colors.grey[100],
            //     child: const CircularProgressIndicator(strokeWidth: 1),
            //   ),
            //   errorWidget: (context, url, error) => Container(
            //     color: Colors.grey[200],
            //     child: Icon(Icons.person, size: radius, color: Colors.grey[400]),
            //   ),
            // ),
          ),
        );
      },
    );
  }
}
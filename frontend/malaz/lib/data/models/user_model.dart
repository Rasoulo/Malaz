// data/models/user_model.dart
import 'package:malaz/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  UserModel({
    required super.id,
    required super.first_name,
    required super.last_name,
    required super.phone,
    required super.role,
    required super.date_of_birth,
    required super.profile_image,
    required super.identity_card_image,
    required super.phone_verified_at,
    required super.created_at,
    required super.updated_at,
  });
// Factory constructor للمستخدم Pending
  factory UserModel.pending({required String phone}) {
    return UserModel(
      id: 0, // أو أي قيمة افتراضية
      first_name: '',
      last_name: '',
      phone: phone,
      role: 'PENDING',
      date_of_birth: '',
      profile_image: '',
      identity_card_image: '',
      phone_verified_at: '',
      created_at: '',
      updated_at: '',
    );
  }
  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      phone: user.phone,
      role: user.role,
      date_of_birth: user.date_of_birth,
      profile_image: user.profile_image,
      identity_card_image: user.identity_card_image,
      phone_verified_at: user.phone_verified_at,
      created_at: user.created_at,
      updated_at: user.updated_at,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      date_of_birth: json['date_of_birth'] ?? '',
      profile_image: json['profile_image'] ?? '',
      identity_card_image: json['identity_card_image'] ?? '',
      phone_verified_at: json['phone_verified_at'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'phone': phone,
      'role': role,
      'date_of_birth': date_of_birth,
      'profile_image': profile_image,
      'identity_card_image': identity_card_image,
      'phone_verified_at': phone_verified_at,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
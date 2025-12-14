import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final int id;
  final String first_name;
  final String last_name;
  final String phone;
  final String role;
  final String date_of_birth;
  final String profile_image;
  final String identity_card_image;
  final String phone_verified_at;
  final String created_at;
  final String updated_at;

  UserEntity({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.phone,
    required this.role,
    required this.date_of_birth,
    required this.profile_image,
    required this.identity_card_image,
    required this.phone_verified_at,
    required this.created_at,
    required this.updated_at,
  });

  factory UserEntity.emptyPending() {
    return UserEntity(
      id: 0,
      role: 'PENDING',
      first_name: '',
      last_name: '',
      phone: '',
      date_of_birth: '',
      profile_image: '',
      identity_card_image: '',
      phone_verified_at: '',
      created_at: '',
      updated_at: '',
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    first_name,
    last_name,
    phone,role,
    date_of_birth,
    profile_image,
    identity_card_image,
    phone_verified_at,
    created_at,
    updated_at
  ];

}
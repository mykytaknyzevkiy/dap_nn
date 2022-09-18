import 'package:dap_app_new/models/TrackModel.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String created;
  final String phone;
  final bool verificated;
  String token;
  final String imageUrl =
      'https://www.pngitem.com/pimgs/m/78-786293_1240-x-1240-0-avatar-profile-icon-png.png';
  final List<String> trackIds;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.created,
      required this.phone,
      required this.verificated,
      required this.token,
      required this.trackIds});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final token = json.containsKey('token') ? json['token'] : '';
    return UserModel(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        created: json['created'],
        phone: json['phone'],
        verificated: json['verificated'],
        token: token,
        trackIds: (json['tracks'] as List).map((it) => it.toString()).toList());
  }
}

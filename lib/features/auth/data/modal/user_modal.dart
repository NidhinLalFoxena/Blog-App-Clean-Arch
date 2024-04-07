import 'package:blog_app_cleanarch/core/common/entities/user.dart';

class UserModal extends User {
  UserModal({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModal.fromJson(Map<String, dynamic> map) {
    return UserModal(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  UserModal copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModal(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

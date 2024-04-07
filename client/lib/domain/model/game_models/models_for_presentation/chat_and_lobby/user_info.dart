import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;

  UserInfo._({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserInfo &&
        other.id == id &&
        other.name == name &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ avatarUrl.hashCode;

  factory UserInfo.fromJson(Map<String, dynamic> k) {
    final user = UserInfo._(
      id: k['id'] as String,
      name: k['username'] as String,
      avatarUrl: k['avatar'] as String,
    );
    return user;
  }

  @override
  List<Object?> get props => [id, name, avatarUrl];
  static Map<String, UserInfo> _users = {};
  static UserInfo? tryGetUserInfoById(String id) {
    return _users[id];
  }

  static void addUserInfo(UserInfo userInfo) {
    _users[userInfo.id] = userInfo;
  }

  static void addUsersInfos(Map<String, UserInfo> usersInfos) {
    _users.addAll(usersInfos);
  }
}

import 'package:mochi/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String username;
  final String email;
  final List history;
  final List readingList;
  final List favouriteManga;
  final int timeSpent;
  final String password;

  const UserModel({
    required this.username,
    required this.email,
    required this.history,
    required this.readingList,
    required this.favouriteManga,
    required this.timeSpent,
    required this.password,
  }) : super(
          username: username,
          email: email,
          history: history,
          readingList: readingList,
          favouriteManga: favouriteManga,
          timeSpent: timeSpent,
          password: password,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      history: List.from(json['history']),
      readingList: List.from(json['readingList']),
      favouriteManga: List.from(json['favouriteManga']),
      timeSpent: json['timeSpent'],
      password: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'history': history,
      'readingList': readingList,
      'favouriteManga': favouriteManga,
      'timeSpent': timeSpent,
    };
  }
}

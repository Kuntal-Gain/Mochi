// ignore_for_file: overridden_fields

import 'package:mochi/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  @override
  final String username;
  @override
  final String email;
  @override
  final List history;
  @override
  final List readingList;
  @override
  final List favouriteManga;
  @override
  final int timeSpent;
  @override
  final String password;
  @override
  final String uid;

  const UserModel({
    required this.username,
    required this.email,
    required this.history,
    required this.readingList,
    required this.favouriteManga,
    required this.timeSpent,
    required this.password,
    required this.uid,
  }) : super(
          username: username,
          email: email,
          history: history,
          readingList: readingList,
          favouriteManga: favouriteManga,
          timeSpent: timeSpent,
          password: password,
          uid: uid,
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
      uid: json['uid'],
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
      'uid': uid,
    };
  }
}

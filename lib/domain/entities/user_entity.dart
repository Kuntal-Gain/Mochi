import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String username;
  final String email;
  final List history;
  final List readingList;
  final List favouriteManga;
  final int timeSpent;
  final String password;

  const UserEntity({
    required this.username,
    required this.email,
    required this.history,
    required this.readingList,
    required this.favouriteManga,
    required this.timeSpent,
    required this.password,
    required this.uid,
  });

  @override
  List<Object?> get props => [
        username,
        email,
        history,
        readingList,
        favouriteManga,
        timeSpent,
        password,
        uid,
      ];
}

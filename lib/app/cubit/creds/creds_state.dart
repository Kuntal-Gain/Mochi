part of 'creds_cubit.dart';

abstract class CredsState extends Equatable {
  const CredsState();
}

class CredsInitial extends CredsState {
  @override
  List<Object> get props => [];
}

class CredsLoading extends CredsState {
  @override
  List<Object> get props => [];
}

class CredsSuccess extends CredsState {
  @override
  List<Object> get props => [];
}

class CredsFailure extends CredsState {
  final String message;
  const CredsFailure({required this.message});
  @override
  List<Object> get props => [message];
}

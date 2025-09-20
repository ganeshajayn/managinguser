part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserEntity> users;
  UserLoaded(this.users);
}

class SingleUserLoaded extends UserState {
  final UserEntity user;
  SingleUserLoaded(this.user);
}

class UserCreated extends UserState {
  final UserEntity user;
  UserCreated(this.user);
}

class UserUpdated extends UserState {
  final UserEntity user;
  UserUpdated(this.user);
}

class UserDeleted extends UserState {}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

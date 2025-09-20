part of 'user_bloc.dart';

abstract class UserEvent {}

class GetUsersEvent extends UserEvent {
  final int page;
  GetUsersEvent(this.page);
}

class GetUserEvent extends UserEvent {
  final int id;
  GetUserEvent(this.id);
}

class CreateUserEvent extends UserEvent {
  final Map<String, dynamic> userData;
  CreateUserEvent(this.userData);
}

class UpdateUserEvent extends UserEvent {
  final int id;
  final Map<String, dynamic> userData;
  UpdateUserEvent(this.id, this.userData);
}

class DeleteUserEvent extends UserEvent {
  final int id;
  DeleteUserEvent(this.id);
}

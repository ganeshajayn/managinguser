import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machinetest/features/users/domain/respositories/user_respository.dart';

import '../../../domain/entities/user_entities.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    /// Fetch list of users
    on<GetUsersEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await repository.getUsers(event.page);
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    /// Fetch single user
    on<GetUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await repository.getUser(event.id);
        emit(SingleUserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    /// Create user
    on<CreateUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await repository.createUser(event.userData);
        emit(UserCreated(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    /// Update user
    on<UpdateUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await repository.updateUser(event.id, event.userData);
        emit(UserUpdated(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    /// Delete user
    on<DeleteUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        await repository.deleteUser(event.id);
        emit(UserDeleted());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}

import 'package:machinetest/features/users/domain/entities/user_entities.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsers(int page);
  Future<UserEntity> getUser(int id);
  Future<UserEntity> createUser(Map<String, dynamic> userData);
  Future<UserEntity> updateUser(int id, Map<String, dynamic> userData);
  Future<void> deleteUser(int id);
}

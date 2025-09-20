import 'package:machinetest/features/users/data/datasoruces/user_remote_datausers.dart';
import 'package:machinetest/features/users/domain/entities/user_entities.dart';
import 'package:machinetest/features/users/domain/respositories/user_respository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<UserEntity>> getUsers(int page) async {
    final models = await remoteDataSource.getUsers(page);
    return models; // ✅ already UserEntity because UserModel extends UserEntity
  }

  @override
  Future<UserEntity> getUser(int id) async {
    return await remoteDataSource.getUser(id);
  }

  @override
  Future<UserEntity> createUser(Map<String, dynamic> userData) async {
    return await remoteDataSource.createUser(userData);
  }

  @override
  Future<UserEntity> updateUser(int id, Map<String, dynamic> userData) async {
    return await remoteDataSource.updateUser(id, userData);
  }

  @override
  Future<void> deleteUser(int id) async {
    await remoteDataSource.deleteUser(id);
  }
}

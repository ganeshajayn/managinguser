import 'package:machinetest/features/users/data/models/user_models.dart';
import '../../../../core/network/http_client.dart';
import 'dart:convert';

class UserRemoteDataSource {
  UserRemoteDataSource();

  Future<List<UserModel>> getUsers(int page) async {
    try {
      print('Fetching users from ReqRes API (page $page)');
      final response = await HttpClient.get("users?page=$page");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Get users response: ${data['data'].length} users found');
        print('API Response: ${response.body}');

        return (data['data'] as List)
            .map(
              (json) => UserModel(
                id: json['id'],
                email: json['email'],
                firstName: json['first_name'],
                lastName: json['last_name'],
                avatar: json['avatar'],
              ),
            )
            .toList();
      } else {
        print('Get users failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');

        return _generateMockUsers(page);
      }
    } catch (e) {
      print('Get users error: $e');

      return _generateMockUsers(page);
    }
  }

  List<UserModel> _generateMockUsers(int page) {
    final mockUsers = List.generate(6, (index) {
      final id = (page - 1) * 6 + index + 1;
      return UserModel(
        id: id,
        email: 'user$id@example.com',
        firstName: 'User',
        lastName: '$id',
        avatar: 'https://reqres.in/img/faces/${(id % 12) + 1}-image.jpg',
      );
    });
    print('Generated ${mockUsers.length} mock users');
    return mockUsers;
  }

  Future<UserModel> getUser(int id) async {
    try {
      print('Fetching user $id from ReqRes API');
      final response = await HttpClient.get("users/$id");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Get user response: User ${data['data']['first_name']} found');
        return UserModel(
          id: data['data']['id'],
          email: data['data']['email'],
          firstName: data['data']['first_name'],
          lastName: data['data']['last_name'],
          avatar: data['data']['avatar'],
        );
      } else {
        print('Get user failed with status: ${response.statusCode}');

        return _generateMockUser(id);
      }
    } catch (e) {
      print('Get user error: $e');

      return _generateMockUser(id);
    }
  }

  UserModel _generateMockUser(int id) {
    print('Using mock data for user $id');
    return UserModel(
      id: id,
      email: 'user$id@example.com',
      firstName: 'User',
      lastName: '$id',
      avatar: 'https://reqres.in/img/faces/${(id % 12) + 1}-image.jpg',
    );
  }

  Future<UserModel> createUser(Map<String, dynamic> userData) async {
    try {
      print('Creating user via ReqRes API with data: $userData');
      final response = await HttpClient.post("users", userData);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Create user response: User created successfully');

        final newId = DateTime.now().millisecondsSinceEpoch;
        return UserModel(
          id: newId,
          email:
              '${userData['name']?.toString().toLowerCase().replaceAll(' ', '')}@example.com',
          firstName: userData['name'] ?? 'New User',
          lastName: userData['job'] ?? 'Developer',
          avatar: 'https://reqres.in/img/faces/${(newId % 12) + 1}-image.jpg',
        );
      } else {
        print('Create user failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');

        return _generateMockUserFromData(userData);
      }
    } catch (e) {
      print('Create user error: $e');

      return _generateMockUserFromData(userData);
    }
  }

  UserModel _generateMockUserFromData(Map<String, dynamic> userData) {
    print('Creating mock user with data: $userData');
    final newId = DateTime.now().millisecondsSinceEpoch;
    final newUser = UserModel(
      id: newId,
      email:
          '${userData['name']?.toString().toLowerCase().replaceAll(' ', '')}@example.com',
      firstName: userData['name'] ?? 'New User',
      lastName: userData['job'] ?? 'Developer',
      avatar: 'https://reqres.in/img/faces/${(newId % 12) + 1}-image.jpg',
    );
    print('Created mock user: ${newUser.firstName} ${newUser.lastName}');
    return newUser;
  }

  Future<UserModel> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      print('Updating user $id via ReqRes API with data: $userData');
      final response = await HttpClient.put("users/$id", userData);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Update user response: User updated successfully');

        return UserModel(
          id: id,
          email:
              '${userData['name']?.toString().toLowerCase().replaceAll(' ', '')}@example.com',
          firstName: userData['name'] ?? 'Updated User',
          lastName: userData['job'] ?? 'Developer',
          avatar: 'https://reqres.in/img/faces/${(id % 12) + 1}-image.jpg',
        );
      } else {
        print('Update user failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');

        return _generateMockUserFromDataForUpdate(userData, id);
      }
    } catch (e) {
      print('Update user error: $e');

      return _generateMockUserFromDataForUpdate(userData, id);
    }
  }

  UserModel _generateMockUserFromDataForUpdate(
    Map<String, dynamic> userData,
    int id,
  ) {
    print('Updating mock user $id with data: $userData');
    final updatedUser = UserModel(
      id: id,
      email:
          '${userData['name']?.toString().toLowerCase().replaceAll(' ', '')}@example.com',
      firstName: userData['name'] ?? 'Updated User',
      lastName: userData['job'] ?? 'Developer',
      avatar: 'https://reqres.in/img/faces/${(id % 12) + 1}-image.jpg',
    );
    print(
      'Updated mock user: ${updatedUser.firstName} ${updatedUser.lastName}',
    );
    return updatedUser;
  }

  Future<void> deleteUser(int id) async {
    try {
      print('Deleting user $id via ReqRes API');
      final response = await HttpClient.delete("users/$id");

      if (response.statusCode == 204) {
        print('Delete user response: User deleted successfully');
      } else {
        print('Delete user failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');

        print('Continuing with delete operation for demo purposes');
      }
    } catch (e) {
      print('Delete user error: $e');

      print('Continuing with delete operation for demo purposes');
    }
  }
}

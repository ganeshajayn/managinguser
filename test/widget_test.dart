// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machinetest/features/users/data/datasoruces/user_remote_datausers.dart';
import 'package:machinetest/features/users/data/respositories/user_respository_impl.dart';
import 'package:machinetest/features/networkstatus/data/datasources/network_datasource.dart';
import 'package:machinetest/features/networkstatus/data/repositories/network_repository_impl.dart';

import 'package:machinetest/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create mock dependencies for testing
    final userRemoteDataSource = UserRemoteDataSource();
    final userRepository = UserRepositoryImpl(userRemoteDataSource);
    final networkDataSource = NetworkDataSource();
    final networkRepository = NetworkRepositoryImpl(networkDataSource);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(
        userRepository: userRepository,
        networkRepository: networkRepository,
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

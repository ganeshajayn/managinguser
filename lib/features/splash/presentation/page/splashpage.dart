import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machinetest/core/services/notification_service.dart';
import 'package:machinetest/features/auth/data/respositories/auth_respository.dart';
import 'package:machinetest/features/splash/bloc/bloc/splash_bloc.dart';

class Splashpage extends StatelessWidget {
  const Splashpage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc(AuthRespository())..add(CheckAuthEvents()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Check for pending notification route first
            final notificationService = NotificationService();
            final pendingRoute = notificationService.pendingRoute;

            if (pendingRoute != null) {
              // Clear the pending route and navigate
              notificationService.clearPendingRoute();
              Navigator.pushReplacementNamed(context, pendingRoute);
            } else if (state is SplashAuthenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is SplashUnauthenticated) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          });
        },
        child: const Scaffold(body: Center(child: FlutterLogo(size: 120))),
      ),
    );
  }
}

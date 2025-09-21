import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
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
            final notificationService = NotificationService();
            final pendingRoute = notificationService.pendingRoute;

            if (pendingRoute != null) {
              notificationService.clearPendingRoute();
              Navigator.pushReplacementNamed(context, pendingRoute);
            } else if (state is SplashAuthenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is SplashUnauthenticated) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          });
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  "assets/lottie/Management.json",
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  "U S E R  H U B",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

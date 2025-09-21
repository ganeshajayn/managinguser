import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:machinetest/core/localization/app_localizations.dart';
import 'package:machinetest/core/providers/language_provider.dart';
import 'package:machinetest/core/services/notification_service.dart';
import 'package:machinetest/features/auth/presentation/pages/loginpage.dart';
import 'package:machinetest/features/splash/presentation/page/splashpage.dart';
import 'package:machinetest/features/users/data/datasoruces/user_remote_datausers.dart';
import 'package:machinetest/features/users/data/respositories/user_respository_impl.dart';
import 'package:machinetest/features/users/presentation/bloc/bloc/user_bloc.dart';
import 'package:machinetest/features/users/presentation/pages/home_screen.dart';
import 'package:machinetest/features/profile/presentation/pages/profile_page.dart';
import 'package:machinetest/features/networkstatus/data/datasources/network_datasource.dart';
import 'package:machinetest/features/networkstatus/data/repositories/network_repository_impl.dart';
import 'package:machinetest/features/networkstatus/presentation/bloc/network_bloc.dart';
import 'package:machinetest/features/networkstatus/presentation/pages/no_network_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService().initialize();

  final userRemoteDataSource = UserRemoteDataSource();
  final userRepository = UserRepositoryImpl(userRemoteDataSource);

  final networkDataSource = NetworkDataSource();
  final networkRepository = NetworkRepositoryImpl(networkDataSource);

  runApp(
    MyApp(userRepository: userRepository, networkRepository: networkRepository),
  );
}

class MyApp extends StatelessWidget {
  final UserRepositoryImpl userRepository;
  final NetworkRepositoryImpl networkRepository;

  const MyApp({
    super.key,
    required this.userRepository,
    required this.networkRepository,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<NetworkBloc>(
                create: (_) => NetworkBloc(networkRepository),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'User Hub',
              localizationsDelegates: const [
                LocalizationDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', ''), Locale('hi', '')],
              locale: languageProvider.currentLocale,
              home: const Splashpage(),
              routes: {
                '/login': (_) => const Loginpage(),
                '/home': (_) => BlocProvider(
                  create: (_) => UserBloc(userRepository),
                  child: const HomeScreen(),
                ),
                '/profile': (_) => const ProfilePage(),
                '/no-network': (_) => const NoNetworkPage(),
              },
            ),
          );
        },
      ),
    );
  }
}

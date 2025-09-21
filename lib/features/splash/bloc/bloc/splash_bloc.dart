import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machinetest/features/auth/data/respositories/auth_respository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRespository authRespository;

  SplashBloc(this.authRespository) : super(SplashInitial()) {
    on<CheckAuthEvents>((event, emit) async {
      emit(Splashloading());
      await Future.delayed(const Duration(seconds: 4));
      final user = authRespository.getCurrentUser();
      if (user != null) {
        emit(SplashAuthenticated());
      } else {
        emit(SplashUnauthenticated());
      }
    });
  }
}

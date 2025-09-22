import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(WelcomeInitial());

  void startLoading() {
    emit(const WelcomeLoading());
    Future.delayed(Duration(seconds: 2), () {
      emit(const WelcomeSuccess());
    });
  }

  void finishSuccess() {
    emit(const WelcomeSuccess());
  }

  void reset() {
    emit(const WelcomeInitial());
  }
}

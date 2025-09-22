import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'button_state.dart';

class ButtonCubit extends Cubit<ButtonState> {
  ButtonCubit() : super(ButtonIdle());

  void submit() async {
    emit(ButtonLoading());
    await Future.delayed(const Duration(seconds: 2)); // simulate API call

    // you can decide success/failure
    emit(ButtonSuccess());
  }

  void reset() => emit(ButtonIdle());
}

part of 'button_cubit.dart';

sealed class ButtonState extends Equatable {
  const ButtonState();

  @override
  List<Object> get props => [];
}

class ButtonIdle extends ButtonState {}

class ButtonLoading extends ButtonState {}

class ButtonSuccess extends ButtonState {}

class ButtonFailure extends ButtonState {}

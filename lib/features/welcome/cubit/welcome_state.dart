part of 'welcome_cubit.dart';

sealed class WelcomeState extends Equatable {
  final bool isLoading;
  const WelcomeState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

final class WelcomeInitial extends WelcomeState {
  const WelcomeInitial() : super(false);
}

final class WelcomeLoading extends WelcomeState {
  const WelcomeLoading() : super(true);
}

final class WelcomeSuccess extends WelcomeState {
  const WelcomeSuccess() : super(false);
}

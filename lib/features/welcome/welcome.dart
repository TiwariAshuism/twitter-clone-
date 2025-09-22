import 'package:chirper/core/navigation/navigation_service.dart';
import 'package:chirper/core/navigation/page_trasition.dart';
import 'package:chirper/core/navigation/route_paths.dart';
import 'package:chirper/core/presentation/widgets/loading_button.dart';
import 'package:chirper/core/presentation/widgets/texttile.dart';
import 'package:chirper/features/welcome/cubit/welcome_cubit.dart';
import 'package:chirper/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Image.asset("assets/images/icon-48.png", width: double.infinity),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20),
        child: Column(
          children: [
            Spacer(),
            Center(
              child: const TitleText(
                'See what\'s happening in the world right now.',
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            BlocProvider(
              create: (context) => WelcomeCubit(),
              child: BlocConsumer<WelcomeCubit, WelcomeState>(
                listener: (context, state) {
                  if (state is WelcomeSuccess) {
                    Future.microtask(() {
                      NavigationService.pushNamed(
                        Routes.register,
                        animationType: AnimationType.scaleIn,
                      );
                    });
                  }
                },
                builder: (context, state) {
                  return GenericCustomButton<WelcomeCubit, WelcomeState>(
                    label: "Create Account",
                    borderRadius: 25,
                    bloc: context.read<WelcomeCubit>(),
                    isLoadingCondition: (state) => state is WelcomeLoading,
                    isEnabledCondition: (state) => state is! WelcomeLoading,
                    onPressed: () {
                      context.read<WelcomeCubit>().startLoading();
                    },
                  );
                },
              ),
            ),

            Spacer(),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                const Text(
                  'Have an account already?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                InkWell(
                  onTap: () {
                    NavigationService.pushNamed(Routes.login);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 10,
                    ),
                    child: Text(
                      ' Log in',
                      style: TextStyle(
                        fontSize: 14,
                        color: TwitterColor.dodgeBlue,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

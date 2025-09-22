import 'package:chirper/core/navigation/navigation_service.dart';
import 'package:chirper/core/navigation/route_paths.dart';
import 'package:chirper/core/presentation/widgets/loading_button.dart';
import 'package:chirper/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Artboard? _artboard;
  StateMachineController? _controller;
  SMIInput<bool>? _trigSuccess;
  SMIInput<bool>? _trigFail;
  SMIInput<bool>? _isChecking;
  SMIInput<bool>? _isHandsUp;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginSuccess() {
    _trigSuccess?.change(true);
    NavigationService.showSuccess("Logged in successfully!");
    NavigationService.pushNamedAndRemoveUntil(Routes.home);
  }

  void _onLoginFailure(String message) {
    _trigFail?.change(true);
    NavigationService.showError(message);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Email login"),
        centerTitle: true, // This ensures the title is centered
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            _onLoginSuccess();
          } else if (state.status == LoginStatus.failure) {
            _onLoginFailure("Login failed. Please check your credentials.");
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔹 Rive Animation
              SizedBox(
                width: size.width,
                height: size.height * 0.45,
                child: RiveAnimation.asset(
                  "assets/rive/bear.riv",
                  fit: BoxFit.cover,
                  stateMachines: const ["Login Machine"],
                  onInit: (artboard) {
                    _artboard = artboard;
                    _controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    if (_controller == null) return;
                    artboard.addController(_controller!);
                    _isChecking = _controller?.findInput("isChecking");
                    _isHandsUp = _controller?.findInput("isHandsUp");
                    _trigFail = _controller?.findInput("trigFail");
                    _trigSuccess = _controller?.findInput("trigSuccess");
                  },
                ),
              ),

              // 🔹 Login Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    _buildTextField(
                      controller: _emailController,
                      hint: "Enter email",
                      onFocusChange: (hasFocus) =>
                          _isChecking?.change(hasFocus),
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _passwordController,
                      hint: "Enter password",
                      obscureText: true,
                      onFocusChange: (hasFocus) => _isHandsUp?.change(hasFocus),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return GenericCustomButton<LoginBloc, LoginState>(
                          label: "Email Login",
                          borderRadius: 25,
                          bloc: context.read<LoginBloc>(),
                          isLoadingCondition: (state) =>
                              state.status == LoginStatus.loading,
                          isEnabledCondition: (state) =>
                              state.status != LoginStatus.loading,
                          onPressed: () {
                            context.read<LoginBloc>().add(
                              LoginSubmitted(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    required Function(bool) onFocusChange,
  }) {
    return Focus(
      onFocusChange: onFocusChange,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
          ),
        ),
      ),
    );
  }
}

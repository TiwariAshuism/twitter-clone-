import 'package:chirper/core/presentation/widgets/loading_button.dart';
import 'package:chirper/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onRegisterButtonPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
        RegisterSubmitted(
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Register"), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // 🔹 Top Image / Animation placeholder
              // Container(
              //   height: size.height * 0.25,
              //   width: size.width,
              //   decoration: BoxDecoration(
              //     color: Colors.blue.shade100,
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   alignment: Alignment.center,
              //   child: const Text(
              //     "✨ Welcome! ✨",
              //     style: TextStyle(
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.blue,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 32),

              // 🔹 Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      hint: "Email",
                      onFocusChange: (hasFocus) {},
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _usernameController,
                      hint: "Username",
                      onFocusChange: (hasFocus) {},
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      hint: "Password",
                      obscureText: true,
                      onFocusChange: (hasFocus) {},
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Register Button
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return GenericCustomButton<RegisterBloc, RegisterState>(
                          label: "Register",
                          borderRadius: 25,
                          bloc: context.read<RegisterBloc>(),
                          isLoadingCondition: (state) =>
                              state.status == RegisterStatus.loading,
                          isEnabledCondition: (state) =>
                              state.status != RegisterStatus.loading,
                          onPressed: _onRegisterButtonPressed,
                        );
                      },
                    ),

                    const SizedBox(height: 16),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/colors.dart';
import '../res/round_button.dart';
import '../view_model/auth_view_model.dart';
import '../../utils/utils.dart';
import '../../utils/routes/routes_name.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {

    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handles the sign-up logic when the button is pressed
  void _handleSignUp(AuthViewModel authViewModel) {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    authViewModel.signUp(
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authViewModel.status == AuthStatus.Error && authViewModel.errorMessage != null) {
            Utils.flushBarErrorMessage(authViewModel.errorMessage!, context);
          }
          else if (authViewModel.status == AuthStatus.Authenticated) {
            Navigator.of(context).pushNamed(
              RoutesName.login,
            );
          }
        });

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.redColor,
            title: const Text('Sign Up'),
            centerTitle: true,
          ),
            body: Form(
              key: _formKey,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.redColor,
                      AppColors.greenColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    transform: GradientRotation(60 * (3.14159265358979323846 / 180)),
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Text('Welcome!', style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                    Text('Sign In to start using the App today', style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic)),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled:true,
                          fillColor: AppColors.whiteColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.redColor),
                          ),
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled:true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          filled:true,
                          fillColor: AppColors.whiteColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.redColor),
                          ),
                          hintText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length<6) {
                            return 'Enter a password longer than 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    RoundButton(
                    title: 'Login',
                    loading: authViewModel.status == AuthStatus.Authenticating,
                    onPress: () {
                      if (authViewModel.status != AuthStatus.Authenticating) {
                      _handleSignUp(authViewModel);
                      }
                    },
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RoutesName.login);
                          },
                          child: const Text('Login', style: TextStyle(fontSize: 20),),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}

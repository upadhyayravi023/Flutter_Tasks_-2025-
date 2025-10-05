import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rudraksha_task_3/utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../res/colors.dart';
import '../res/round_button.dart';
import '../view_model/auth_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(AuthViewModel authViewModel) {

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (email.isEmpty || password.isEmpty) {
      Utils.flushBarErrorMessage("Email and password cannot be empty.", context);
      return;
    }

    authViewModel.signIn(
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
          } else if (authViewModel.status == AuthStatus.Authenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesName.home,
                  (route) => false,
            );
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            centerTitle: true,
            backgroundColor: AppColors.redColor,
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
                    Text('Welcome Back!', style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                    Text('Login to start using the app again!', style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic),),
                    SizedBox(height: 80),
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
                    const SizedBox(height: 20),
                    RoundButton(
                      title: 'Login',
                      loading: authViewModel.status == AuthStatus.Authenticating,
                      onPress: () {
                        if (authViewModel.status != AuthStatus.Authenticating) {
                          _handleLogin(authViewModel);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?", style: TextStyle(fontSize: 20),),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RoutesName.signup);
                          },
                          child: const Text('Sign Up', style: TextStyle(fontSize: 20),),
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

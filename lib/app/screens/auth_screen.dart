import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/app/cubit/creds/creds_cubit.dart';
import 'package:mochi/app/screens/home_screen.dart';
import 'package:mochi/domain/entities/user_entity.dart';
import 'package:mochi/utils/constants/size_constants.dart';
import 'package:mochi/utils/constants/text_constants.dart';

import '../../utils/constants/color_constants.dart';
import '../../utils/widgets/custom_snackbar.dart';
import '../cubit/auth/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = false;

  void _submitRegister() {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    BlocProvider.of<CredsCubit>(context).signUpUser(
      user: UserEntity(
        username: username,
        email: email,
        history: const [],
        readingList: const [],
        favouriteManga: const [],
        timeSpent: 0,
        password: password,
        uid: '', // Leave empty if generated server-side
      ),
    );
  }

  void _submitLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password are required")),
      );
      return;
    }

    BlocProvider.of<CredsCubit>(context).signInUser(
      email: email,
      password: password,
    );
  }

  _bodyWidget() {
    return Column(
      children: [
        sizeVer(12),
        Center(
          child: Image.asset(
            'assets/logo.png',
            width: 250,
            height: 250,
          ),
        ),
        sizeVer(30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary,
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              sizeVer(15),
              if (!isLogin)
                Container(
                  height: 60,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary,
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              sizeVer(15),
              Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary,
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              sizeVer(20),
              GestureDetector(
                onTap: () {
                  isLogin ? _submitLogin() : _submitRegister();
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      isLogin ? "Login" : "Create Account",
                      style: TextConst.headingStyle(
                        18,
                        AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              sizeVer(10),
              RichText(
                text: TextSpan(
                  text: isLogin
                      ? "Don't have an account? "
                      : "Already have an account? ",
                  style: TextConst.MediumStyle(
                    18,
                    AppColors.black,
                  ), // Default text color
                  children: [
                    TextSpan(
                      text: isLogin ? 'Create now' : 'Login',
                      style: TextStyle(
                        color:
                            AppColors.primary, // Highlighted action text color
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle the tap event
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<CredsCubit, CredsState>(
        listener: (context, state) {
          if (state is CredsSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }

          if (state is CredsFailure) {
            failureBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CredsSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return HomeScreen(uid: state.uid);
                } else {
                  return _bodyWidget();
                }
              },
            );
          }

          return _bodyWidget();
        },
      ),
    );
  }
}

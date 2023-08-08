import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/common/rounded_rectangle_button.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/auth/view/signup_view.dart';
import 'package:courtfinder/features/auth/widgets/auth_field.dart';
import 'package:courtfinder/theme/pallete.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() {
    ref
        .read(authControllerProvider.notifier)
        .login(email: emailController.text, password: passwordController.text, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Email AuthField
                      AuthField(controller: emailController, hintText: '邮件', type: "normal"),
                      const SizedBox(height: 25),
                      // Password AuthField
                      AuthField(controller: passwordController, hintText: '密码', type: "password"),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.center,
                        child: RoundedRectangleButton(
                          onTap: onLogin,
                          label: 'Done',
                        ),
                      ),
                      const SizedBox(height: 40),
                      RichText(
                        text: TextSpan(
                          text: "没有账号?",
                          style: const TextStyle(color: Pallete.blackColor, fontSize: 16),
                          children: [
                            TextSpan(
                              text: ' 注册',
                              style: const TextStyle(color: Pallete.orangeColor, fontSize: 16),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, SignUpView.route());
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

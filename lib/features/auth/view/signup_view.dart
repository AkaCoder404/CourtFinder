import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/common.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/common/rounded_rectangle_button.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/auth/view/login_view.dart';
import 'package:courtfinder/features/auth/widgets/auth_field.dart';
import 'package:courtfinder/theme/theme.dart';

// ConsumerStateful gives us access to ref

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpView());
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    ref
        .read(authControllerProvider.notifier)
        .signUp(email: emailController.text, password: passwordController.text, context: context);
  }

  @override
  Widget build(BuildContext context) {
    // If data is loading, show loadingPage
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
                      // textfield 1
                      AuthField(
                        controller: emailController,
                        hintText: '邮件',
                        type: 'normal',
                      ),
                      const SizedBox(height: 25),
                      AuthField(
                        controller: passwordController,
                        hintText: '密码',
                        type: 'password',
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.center,
                        child: RoundedRectangleButton(
                          label: "注册",
                          onTap: onSignUp,
                        ),
                      ),
                      const SizedBox(height: 40),
                      RichText(
                        text: TextSpan(
                          text: "已经有账号?",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Pallete.blackColor,
                          ),
                          children: [
                            TextSpan(
                              text: ' 登记',
                              style: const TextStyle(
                                color: Pallete.orangeColor,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    LoginView.route(),
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
            ),
    );
  }
}

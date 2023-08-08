import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/apis/auth_api.dart';
import 'package:courtfinder/apis/user_api.dart';
import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/auth/view/login_view.dart';
import 'package:courtfinder/features/auth/view/signup_view.dart';
import 'package:courtfinder/features/home/view/home_view.dart';
import 'package:courtfinder/models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

// For current user
final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

// For all users
final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state = isLoading

  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true; // isLoading = true
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false; // isLoading = false
    res.fold(
      (l) => showSnackBar(context, l.message), // handle error
      (r) async {
        // handle success
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic:
              'https://ts1.cn.mm.bing.net/th/id/R-C.040d94d8cb49d199c24a98d50b7263e4?rik=oRyeUxwya0s0yg&riu=http%3a%2f%2fwww.clipartbest.com%2fcliparts%2fniB%2fMRz%2fniBMRzyXT.png&ehk=grdqoY9%2bHtNkmrIob8cSsTEwLmwuQeZe5Go7%2fBisZI8%3d&risl=&pid=ImgRaw&r=0',
          bannerPic: 'https://tse4-mm.cn.bing.net/th/id/OIP-C.HZQP5p1OsbHkTwlhd-OyFwHaD7?pid=ImgDet&rs=1',
          uid: r.$id,
          bio: 'Tell us about yourself ~',
          favorites: const [],
          chats: const [],
          isTwitterBlue: false,
        );
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Account created! Please login.');
          Navigator.push(context, LoginView.route());
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.push(context, HomeView.route());
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(context, SignUpView.route(), (route) => false);
    });
  }
}

// 控制主题颜色
import 'package:courtfinder/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: 修改主题颜色
class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: Pallete.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Pallete.backgroundColor,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Pallete.orangeColor,
      )
      // ,
      // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //     selectedItemColor: Pallete.orangeColor,
      //     unselectedItemColor: Pallete.greyColor,
      //     selectedLabelStyle: TextStyle(color: Pallete.orangeColor))
      );
  static final ThemeData darkTheme = ThemeData.dark();
}

class ChangeThemeState extends ChangeNotifier {
  bool darkMode = false;

  void enableDarkMode() {
    darkMode = true;
    notifyListeners();
  }

  void enableLightMode() {
    darkMode = false;
    notifyListeners();
  }
}

final changeTheme = ChangeNotifierProvider.autoDispose((ref) {
  return ChangeThemeState();
});

// 换主题颜色按钮
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.read(changeTheme).darkMode;
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        if (isDarkMode) {
          ref.read(changeTheme.notifier).enableLightMode();
        } else {
          ref.read(changeTheme.notifier).enableDarkMode();
        }
      },
      child: Text('Toggle Theme'),
    );
  }
}

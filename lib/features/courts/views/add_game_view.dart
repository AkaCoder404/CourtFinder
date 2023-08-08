import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/theme/pallete.dart';

class AddGameView extends ConsumerWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddGameView());
  const AddGameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Pallete.blackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "新赛事",
          style: TextStyle(color: Pallete.blackColor),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Add New Game Page",
          style: TextStyle(color: Pallete.blackColor),
        ),
      ),
    );
  }
}

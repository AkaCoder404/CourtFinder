import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/error_page.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/features/explore/controller/explore_controller.dart';
import 'package:courtfinder/features/explore/widgets/search_tile.dart';
import 'package:courtfinder/theme/pallete.dart';

class ExploreView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ExploreView(),
      );
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final appBarTextFieldBorder = OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(50),
    //   borderSide: const BorderSide(
    //     color: Pallete.searchBarColor,
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Pallete.blackColor,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            style: const TextStyle(color: Pallete.blackColor),
            onSubmitted: (value) {
              ref.refresh(searchUserProvider(searchController.text));
              // When using FutureProvider.family, if you call it with the same parameter value multiple times, it will return the previously cached future and will not recreate a new future.
              // This is to avoid redundant network requests or expensive computations.
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(
                left: 20,
              ),
              fillColor: Pallete.lightGreyColor,
              filled: true,
              // enabledBorder: appBarTextFieldBorder,
              // focusedBorder: appBarTextFieldBorder,
              hintText: 'Search Players',
              hintStyle: const TextStyle(color: Pallete.blackColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: const BorderSide(color: Pallete.orangeColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: const BorderSide(color: Pallete.blackColor, width: 2),
              ),
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(searchUserProvider(searchController.text)).when(
                data: (users) {
                  print(searchController.text);
                  print("explore users $users");
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = users[index];
                      return SearchTile(userModel: user);
                    },
                  );
                },
                error: (error, st) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              )
          : const SizedBox(),
    );
  }
}

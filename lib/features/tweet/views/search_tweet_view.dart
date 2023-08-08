// View for searching tweets based on search term

import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_card.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTweetView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SearchTweetView(),
      );
  const SearchTweetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchTweetViewState();
}

class _SearchTweetViewState extends ConsumerState<SearchTweetView> {
  final searchController = TextEditingController();
  Set<String> _selectedKeywords = Set();
  final List<String> keywords = const ['普通发布', '赛事结论', '场地评论', '找人找队', '装备推荐', '赛事推广'];
  bool isShowPosts = false;

  void onSelected(List<String> selectedKeywords) {
    setState(() {
      _selectedKeywords = selectedKeywords.toSet();
    });

    print(selectedKeywords);
  }

  void _onKeywordSelected(String keyword) {
    setState(() {
      if (_selectedKeywords.contains(keyword)) {
        _selectedKeywords.remove(keyword);
      } else if (_selectedKeywords.length == 1) {
        _selectedKeywords.clear();
        _selectedKeywords.add(keyword);
      } else {
        _selectedKeywords.add(keyword);
      }
      onSelected(_selectedKeywords.toList());
    });
  }

  // Search controller
  void onSubmittedSearch(String value) {
    print('Search Tweet Text ${searchController.text}');
    onRefresh();
    setState(() {
      isShowPosts = true;
    });
  }

  void onClearSearch() {
    searchController.clear();
  }

  // Referesh controller
  Future<void> onRefresh() async {
    var value = ref.refresh(searchTweetsProvider(searchController.text)).value;
    print(value);
  }

  // Basic

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(color: Pallete.blackColor)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Pallete.blackColor),
          color: Pallete.blackColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    TextSearchBar(
                      textController: searchController,
                      onSubmitted: onSubmittedSearch,
                      clearText: onClearSearch,
                    ),

                    // TODO: get a list of keywords from the database
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              children: [
                                for (final keyword in keywords)
                                  GestureDetector(
                                    onTap: () => _onKeywordSelected(keyword),
                                    child: Chip(
                                      label: Text(keyword),
                                      backgroundColor:
                                          _selectedKeywords.contains(keyword) ? Colors.orange[200] : Colors.grey[300],
                                    ),
                                  )
                              ],
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.search),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ])),
            )
          ];
        },
        body: isShowPosts
            ? RefreshIndicator(
                onRefresh: onRefresh,
                child: ref.watch(searchTweetsProvider(searchController.text)).when(
                      data: (tweets) {
                        if (tweets.isEmpty && searchController.text.isNotEmpty) {
                          return const Center(
                            child: Text('没有找到相关的推文'),
                          );
                        }

                        print('Search Results ${tweets.length}');
                        return ListView.builder(
                          itemCount: tweets.length,
                          itemBuilder: (context, index) {
                            if (_selectedKeywords.length == 1 &&
                                tweets[index].tweetTag != _selectedKeywords.toList()[0].toString()) {
                              return null;
                            }
                            return TweetCard(
                              tweet: tweets[index],
                              showActions: true,
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, s) {
                        return Center(
                          child: Text(e.toString()),
                        );
                      },
                    ),
              )
            : const SizedBox(),
      ),
    );
  }
}

// Searchbar
class TextSearchBar extends StatelessWidget {
  final TextEditingController textController;
  final void Function(String) onSubmitted;
  final void Function() clearText;
  const TextSearchBar({super.key, required this.textController, required this.onSubmitted, required this.clearText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          IconButton(
            onPressed: clearText,
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }
}

// TODO: Keyterms Searchbar
class KeyTermsSearchBar extends StatelessWidget {
  final TextEditingController textController;
  const KeyTermsSearchBar({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: TextField(
        controller: textController,
        decoration: const InputDecoration(
          hintText: 'Enter some text',
        ),
      ),
    );
  }
}

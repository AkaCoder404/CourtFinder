import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/common/rounded_small_button.dart';
import 'package:courtfinder/constants/assets_constants.dart';
import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const CreateTweetScreen());
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetTextController = TextEditingController();
  int charCount = 0;
  List<File> images = [];
  String _locationText = '';
  String _street = '';
  String _city = '';
  String _country = '';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    tweetTextController.dispose();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _locationText = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      });
      print('Location: $position');

      GeoCode geoCode = GeoCode(apiKey: "756285325715778945462x120568");
      Address address = await geoCode.reverseGeocoding(latitude: position.latitude, longitude: position.longitude);
      print(address);
      setState(() {
        _city = address.city.toString();
        _street = address.streetAddress.toString();
        _country = address.countryName.toString();
      });
    } catch (e) {
      print("Hello $e");
      setState(() {
        _locationText = 'Error getting location: ${e.toString()}';
      });
    }
  }

  void shareTweet() {
    // print("Share Tweet ${_selectedButtons.toList()[0]}");
    if (_city.isEmpty) {
      showSnackBar(context, '无法获取您的位置，请检查您的网络连接');
      return;
    }

    ref.read(tweetControllerProvider.notifier).shareTweet(
          images: images,
          text: tweetTextController.text,
          context: context,
          repliedTo: '',
          repliedToUserId: '',
          tweetTag: _selectedButtons.toList()[0],
          location: _city,
        );
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  final List<String> _buttons = const ['普通发布', '赛事结论', '场地评论', '找人找队', '装备推荐', '赛事推广'];
  final Set<String> _selectedButtons = {'普通发布'};

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Pallete.blackColor,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        title: const Text('发布 Tweet', style: TextStyle(color: Pallete.blackColor)),
        actions: [
          RoundedSmallButton(
            onTap: shareTweet,
            label: '发布',
            backgroundColor: Pallete.orangeColor,
            textColor: Pallete.blackColor,
          ),
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      // color: Colors.amber,
                      height: 150,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(currentUser.profilePic),
                            radius: 25,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,
                              child: TextField(
                                maxLength: 255,
                                controller: tweetTextController,
                                onChanged: (text) {
                                  setState(() {
                                    charCount = text.length;
                                  });
                                },
                                style: const TextStyle(fontSize: 16, color: Pallete.blackColor),
                                decoration: InputDecoration(
                                  hintText: "分享你的想法...",
                                  hintStyle: const TextStyle(
                                    color: Pallete.blackColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  fillColor: Pallete.lightGreyColor,
                                  filled: true,
                                  // prefix: const Text(
                                  //   "Hello",
                                  //   style: TextStyle(color: Pallete.blackColor),
                                  // ),
                                  counter: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    // if (_locationText.isNotEmpty)
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on, color: Colors.black, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            _city.isNotEmpty ? _city : "获取地址信息。。。",
                                            style: const TextStyle(fontSize: 16, color: Pallete.blackColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        child: Text(
                                      '$charCount/255',
                                      style: const TextStyle(fontSize: 16, color: Pallete.blackColor),
                                    ))
                                  ]),

                                  // counterText: '$charCount/255',
                                  // counterStyle: const TextStyle(color: Pallete.blackColor),
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                                minLines: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      width: double.infinity,
                      child: const Text('发布类型',
                          style: TextStyle(
                            color: Pallete.blackColor,
                            fontSize: 20,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _buttons.length,
                        itemBuilder: (context, index) {
                          final button = _buttons[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectedButtons.contains(button)) {
                                  _selectedButtons.remove(button);
                                } else if (_selectedButtons.length == 1) {
                                  _selectedButtons.clear();
                                  _selectedButtons.add(button);
                                } else {
                                  _selectedButtons.add(button);
                                }
                              });
                            },
                            child: Container(
                              width: 75,
                              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              decoration: BoxDecoration(
                                color: _selectedButtons.contains(button) ? Colors.orange : Pallete.lightGreyColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(button),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      width: double.infinity,
                      child: const Text('照片选择',
                          style: TextStyle(
                            color: Pallete.blackColor,
                            fontSize: 20,
                          )),
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Image.file(file),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Pallete.greyColor, width: 0.3),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}

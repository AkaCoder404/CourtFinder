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
import 'package:geocoding/geocoding.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateTweetScreen(),
      );
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

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: 'zh');
      print("Placemarks $placemarks");
      setState(() {
        _street = placemarks[0].street.toString();
        _city = placemarks[0].locality.toString();
      });
    } catch (e) {
      print("Hello $e");
      setState(() {
        _locationText = 'Error getting location: ${e.toString()}';
      });
    }
  }

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
          images: images,
          text: tweetTextController.text,
          context: context,
          repliedTo: '',
          repliedToUserId: '',
        );
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

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
                      // color: Colors.orange,
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                                hintText: "What's happening?",
                                hintStyle: const TextStyle(
                                  color: Pallete.blackColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                fillColor: Pallete.lightGreyColor,
                                filled: true,
                                counterText: '$charCount/255',
                                counterStyle: const TextStyle(color: Pallete.blackColor),
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_locationText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$_locationText : $_city',
                            style: const TextStyle(fontSize: 16, color: Pallete.blackColor)),
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
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}

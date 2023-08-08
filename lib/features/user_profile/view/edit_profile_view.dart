import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/user_profile/controller/user_profile_controller.dart';
import 'package:courtfinder/models/user_model.dart';
import 'package:courtfinder/theme/theme.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => EditProfileView(userModel: userModel),
      );
  final UserModel userModel;
  const EditProfileView({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerFile;
  File? profileFile;

  @override
  void initState() {
    super.initState();
    // nameController = TextEditingController(
    //   text: ref.read(currentUserDetailsProvider).value?.name ?? '',
    // );
    // bioController = TextEditingController(
    //   text: ref.read(currentUserDetailsProvider).value?.bio ?? '',
    // );
    nameController = TextEditingController(
      text: widget.userModel.name,
    );
    bioController = TextEditingController(
      text: widget.userModel.bio,
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profileImage = await pickImage();
    if (profileImage != null) {
      setState(() {
        profileFile = profileImage;
      });
    }
  }

  void submitEditProfile() {
    ref.read(userProfileControllerProvider.notifier).updateUserProfile(
          userModel: widget.userModel.copyWith(
            bio: bioController.text,
            name: nameController.text,
          ),
          context: context,
          bannerFile: bannerFile,
          profileFile: profileFile,
        );
    var w = widget.userModel;
    var b = bioController.text;
    var n = nameController.text;
    print("EditProfileBuild $w $b $n");
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '修改信息',
          style: TextStyle(color: Pallete.blackColor),
        ),
        leading: IconButton(
          color: Pallete.blackColor,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 30),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: submitEditProfile,
            child: const Text(
              '保存',
              style: TextStyle(color: Pallete.blackColor),
            ),
          ),
        ],
      ),
      body: isLoading || widget.userModel == null
          ? const Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(
                                  bannerFile!,
                                  fit: BoxFit.fitWidth,
                                )
                              : widget.userModel.bannerPic.isEmpty
                                  ? Container(
                                      color: Pallete.orangeColor,
                                    )
                                  : Image.network(
                                      widget.userModel.bannerPic,
                                      fit: BoxFit.fitWidth,
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 8,
                        child: GestureDetector(
                          onTap: selectProfileImage,
                          child: profileFile != null
                              ? Container(
                                  margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Image(
                                    image: FileImage(profileFile!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Image(
                                    image: NetworkImage(widget.userModel.profilePic),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          // ? CircleAvatar(
                          //     backgroundImage: FileImage(profileFile!),
                          //     radius: 40,
                          //   )
                          // : CircleAvatar(
                          //     backgroundImage:
                          //         NetworkImage(user.profilePic),
                          //     radius: 40,
                          //   ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Pallete.blackColor),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    contentPadding: const EdgeInsets.all(18),
                    hintStyle: const TextStyle(color: Pallete.blackColor),
                    labelStyle: const TextStyle(color: Pallete.blackColor),
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(color: Pallete.blackColor, width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: bioController,
                  style: const TextStyle(color: Pallete.blackColor),
                  decoration: InputDecoration(
                    hintText: 'Bio',
                    contentPadding: const EdgeInsets.all(18),
                    hintStyle: const TextStyle(color: Pallete.blackColor),
                    labelStyle: const TextStyle(color: Pallete.blackColor),
                    labelText: "Biography",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(color: Pallete.blackColor, width: 1)),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
    );
  }
}

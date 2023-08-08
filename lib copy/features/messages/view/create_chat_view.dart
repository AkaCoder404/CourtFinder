import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:courtfinder/features/messages/controller/message_controller.dart';
import 'package:courtfinder/features/messages/widgets/create_chat_user_tile.dart';
import 'package:courtfinder/models/user_model.dart';
import 'package:courtfinder/theme/pallete.dart';

// class CreateChatView1 extends ConsumerWidget {
//   const CreateChatView1({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {}
// }

class CreateChatView extends ConsumerStatefulWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => CreateChatView(
          userModel: userModel,
        ),
      );
  final UserModel userModel;
  const CreateChatView({super.key, required this.userModel});

  @override
  ConsumerState<CreateChatView> createState() => _CreateChatViewState();
}

class _CreateChatViewState extends ConsumerState<CreateChatView> {
  final searchController = TextEditingController();
  final List<String> _selectedUsers = [];
  bool isShowUsers = false;

  void updateSelectedUsers(String user, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedUsers.add(user);
      } else {
        _selectedUsers.remove(user);
      }
    });
  }

  void toggleSelected(String user) {
    setState(() {
      if (_selectedUsers.contains(user)) {
        _selectedUsers.remove(user);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  void createChatRoom() {
    ref.read(messageControllerProvider.notifier).createChatRoom(
          userId: widget.userModel.uid,
          context: context,
          otherUserId: _selectedUsers[0],
          name: "",
          isGroupChat: false,
          chatRoom: "test",
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messageControllerProvider);
    var contacts = widget.userModel.following;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Chat",
          style: TextStyle(color: Pallete.blackColor),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Pallete.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Pallete.blackColor),
              decoration: InputDecoration(
                hintText: 'Search Users',
                hintStyle: const TextStyle(color: Pallete.blackColor),
                fillColor: Pallete.lightGreyColor,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(color: Pallete.orangeColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(color: Pallete.blackColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (value) => {},
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                final user = contacts[index];
                return CreateChatSearchTile(
                    user: user, isSelected: _selectedUsers.contains(user), onSelected: updateSelectedUsers);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print("Selected Users $_selectedUsers");
              createChatRoom();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.orangeColor,
            ),
            child: Text(
              'Done (${_selectedUsers.length})',
              style: const TextStyle(color: Pallete.blackColor),
            ),
          ),
        ],
      ),
    );
  }
}

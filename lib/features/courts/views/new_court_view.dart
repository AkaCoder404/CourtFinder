import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/theme/pallete.dart';

class AddCourtView extends ConsumerWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddCourtView());
  const AddCourtView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    // final costController = TextEditingController();
    // final membershipController = TextEditingController();
    // final lightingController = TextEditingController();
    // final numberOfCourtsController = TextEditingController();
    final ValueNotifier<int> numberOfCourts = ValueNotifier<int>(0);
    final ValueNotifier<int> cost = ValueNotifier<int>(0);
    final ValueNotifier<int> indoorOutdoor = ValueNotifier<int>(0);

    List<int> courtCountList = [0, 1, 2, 3, 4, 5, 6];
    List<String> courtCountLabelList = ["0", "1", "2", "3", "4", "5", "6+"];

    List<int> lightingList = [0, 1];
    List<String> lightingLabelList = ["No", "Yes"];

    List<int> costList = [0, 1, 2, 3];
    List<String> costLabelList = ["Free", "Paid", "Both", "Unknown"];

    List<int> indoorOutdoorList = [0, 1, 2];
    List<String> indoorOutdoorLabelList = ["Indoor", "Outdoor", "Both"];

    void submitAddCourt() {
      // TODO: Add court to database
      print(numberOfCourts.value);
    }

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
          "新场地",
          style: TextStyle(color: Pallete.blackColor),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              // color: Colors.blue,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      // Do something when button is tapped
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.orange[100],
                      child: const Icon(Icons.photo, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 15),
                  TextButton(
                    onPressed: () {
                      // Do something when button is pressed
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Pallete.orangeColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      textStyle: const TextStyle(fontSize: 16.0),
                    ),
                    child: const Text(
                      'Change Photo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Do something when button is pressed
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      textStyle: const TextStyle(fontSize: 16.0),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: const Text('Remove', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            const Divider(height: 0.5, color: Colors.grey),
            const SizedBox(height: 10),
            buildTextFormField(nameController, "Name", "Enter the name of the court"),
            buildTextFormField(locationController, "Location", "Enter the location of the court"),
            buildDropdownButtonFormField(
                numberOfCourts, courtCountList, courtCountLabelList, "Number of Courts", "Select the number of courts"),
            buildDropdownButtonFormField(indoorOutdoor, indoorOutdoorList, indoorOutdoorLabelList, "Indoor or Outdoor",
                "Select the number of courts"),
            buildDropdownButtonFormField(cost, costList, costLabelList, "Cost", "Select the cost"),
            buildDropdownButtonFormField(
                indoorOutdoor, lightingList, lightingLabelList, "Has Lighting", "Select if the court has lighting"),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextButton(
                onPressed: submitAddCourt,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Pallete.orangeColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
                child: const Text(
                  'Add Court',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TextFormField widget
Container buildTextFormField(TextEditingController controller, String labelText, String hintText) {
  return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Pallete.blackColor),
        decoration: InputDecoration(
            fillColor: Pallete.lightGreyColor,
            filled: true,
            label: Text(labelText, style: const TextStyle(color: Pallete.blackColor)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Pallete.blackColor,
              ),
            ),
            contentPadding: const EdgeInsets.all(22),
            floatingLabelBehavior: FloatingLabelBehavior.always
            // hintText: hintText,
            // hintStyle: const TextStyle(fontSize: 18, color: Pallete.blackColor),
            ),
      ));
}

// DropdownButtonFormField widget
Container buildDropdownButtonFormField(ValueNotifier<int> infoValue, List<int> dropdownItems,
    List<String> dropdownLabels, String labelText, String hintText) {
  return Container(
    height: 70,
    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: DropdownButtonFormField(
      style: const TextStyle(color: Pallete.blackColor),
      iconEnabledColor: Pallete.blackColor,
      items: dropdownItems.map(
        (item) {
          return DropdownMenuItem(
            value: item,
            child: Container(
              // width: double.infinity,
              // height: double.infinity,
              decoration: const BoxDecoration(
                color: Pallete.lightGreyColor,
                border: Border(bottom: BorderSide(color: Pallete.lightGreyColor)),
              ),
              child: Text(
                dropdownLabels[dropdownItems.indexOf(item)],
                style: const TextStyle(color: Pallete.blackColor),
              ),
            ),
          );
        },
      ).toList(),
      value: dropdownItems[0],
      onChanged: (value) => {infoValue.value = value as int},
      decoration: InputDecoration(
        fillColor: Pallete.lightGreyColor,
        filled: true,
        label: Text(labelText, style: const TextStyle(color: Pallete.blackColor)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.blackColor,
          ),
        ),
        contentPadding: const EdgeInsets.all(22),
        // hintText: hintText,
        // hintStyle: const TextStyle(fontSize: 18, color: Pallete.blackColor),
      ),
    ),
  );
}

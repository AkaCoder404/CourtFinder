import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/theme/pallete.dart';

class CourtProfileView extends ConsumerWidget {
  static route() => MaterialPageRoute(builder: (context) => const CourtProfileView());
  const CourtProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> infoButtons = [
      InkResponse(
        onTap: () => {},
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, size: 20),
        ),
      ),
      const SizedBox(width: 10),
      InkResponse(
        onTap: () => {},
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.call, size: 20),
        ),
      ),
      const SizedBox(width: 10),
      InkResponse(
        onTap: () => {},
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.edit, size: 20),
        ),
      ),
    ];

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
          "场地信息",
          style: TextStyle(color: Pallete.blackColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 175,
              width: double.infinity,
              // color: Pallete.orangeColor,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      "https://www.tsinghua.edu.cn/__local/A/83/E4/FAC7A1F5BF79662CCC704BF6076_A6A996EB_3365B.jpg",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    height: 175,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.grey.withOpacity(0.0),
                          Colors.black,
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 15,
                    bottom: 45,
                    child: Text(
                      "THU Zijing Courts",
                      style: TextStyle(color: Pallete.whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Positioned(
                    left: 15,
                    bottom: 25,
                    child: Text(
                      "Tsinghua University Zijing Basketball Courts, Beijing, Haidianqu",
                      style: TextStyle(color: Pallete.whiteColor, fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Center(
                child: Row(
                  children: infoButtons,
                ),
              ),
            ),
            const Divider(height: 0.5, color: Pallete.blackColor),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              // color: Colors.blue,
              child: ElevatedButton(
                onPressed: () {
                  // do something when button is pressed
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(253, 210, 186, 1),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  '打卡',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Pallete.orangeColor),
                ),
              ),
            ),
            const Divider(height: 0.5, color: Pallete.blackColor),
            Container(
              height: 175,
              // color: Colors.green,
              color: Pallete.backgroundColor,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                      height: 30,
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                      child: const Text(
                        "信息",
                        style: TextStyle(color: Pallete.blackColor, fontSize: 20),
                      )),
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 90,
                                child: Column(
                                  children: const [
                                    Text("0.0", style: TextStyle(color: Pallete.blackColor, fontSize: 20)),
                                    Text("reviews", style: TextStyle(color: Pallete.blackColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                child: Column(
                                  children: const [
                                    Text("FREE", style: TextStyle(color: Pallete.blackColor, fontSize: 20)),
                                    Text("cost", style: TextStyle(color: Pallete.blackColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                child: Column(
                                  children: const [
                                    Text("3", style: TextStyle(color: Pallete.blackColor, fontSize: 20)),
                                    Text("courts", style: TextStyle(color: Pallete.blackColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 90,
                                child: Column(
                                  children: const [
                                    Text("0", style: TextStyle(color: Pallete.blackColor, fontSize: 20)),
                                    Text("favorites", style: TextStyle(color: Pallete.blackColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                child: Column(
                                  children: const [
                                    Text("FREE", style: TextStyle(color: Pallete.blackColor, fontSize: 20)),
                                    Text("membership", style: TextStyle(color: Pallete.blackColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                child: Column(
                                  children: const [
                                    Text("YES", style: TextStyle(color: Pallete.blackColor, fontSize: 20)),
                                    Text("lighting", style: TextStyle(color: Pallete.blackColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(height: 0.5, color: Pallete.blackColor),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              height: 200,
              color: Pallete.backgroundColor,
              child: FlutterMap(
                mapController: MapController(),
                options: MapOptions(
                  center: LatLng(40.008406, 116.324643),
                  zoom: MapConstants.defaultZoom,
                  // maxZoom: MapConstants.maxZoom,
                  // minZoom: MapConstants.minZoom,
                  interactiveFlags: 0,
                ),
                nonRotatedChildren: const [],
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                      width: 30,
                      height: 30,
                      point: LatLng(40.008406, 116.324643),
                      builder: (ctx) => InkWell(
                        // onTap: () => showBottomSheet(),
                        child: SvgPicture.asset(
                          AssetsConstants.courtFinderLogo2,
                        ),
                      ),
                    ),
                  ])
                ],
              ),
            ),
            const Divider(height: 0.5, color: Pallete.blackColor),
            Container(
              height: 300,
              color: Pallete.backgroundColor,
              child: Column(
                children: [
                  Container(
                      height: 30,
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                      child: const Text(
                        "场地评论",
                        style: TextStyle(color: Pallete.blackColor, fontSize: 20),
                      )),
                  Expanded(
                      child: Center(
                    child: Container(),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:courtfinder/constants/assets_constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:courtfinder/features/courts/views/court_view.dart';
// import 'package:courtfinder/core/location.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:courtfinder/constants/map_constants.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  final mapController = MapController();
  final searchController = TextEditingController();
  bool isLivePosition = false;
  Position currentPosition = Position(
    latitude: 40.008406,
    longitude: 116.324643,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );
  Position? lastPosition;
  String? long = "";
  String? lat = "";

  @override
  void initState() {
    checkLocationServices();
    getLocation();
    super.initState();
  }

  // TODO Handle permisions for android/ios
  void getLocation() async {
    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    // currentPosition = await determinePosition();
    setState(() {
      currentPosition = currentPosition;
    });
  }

  void checkLocationServices() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print("isServiceEnabled $isServiceEnabled");
    LocationPermission permissions = await Geolocator.checkPermission();
    print("permissions $permissions");
    permissions = await Geolocator.requestPermission();
    print("permissions $permissions");
    setState(() {});
  }

  void turnLiveOnOff() {
    isLivePosition = !isLivePosition;
    setState(() {});
  }
  // Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               const Text('BottomSheet'),
  //               ElevatedButton(
  //                   child: const Text('Close BottomSheet'),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   })
  //             ],
  //           ),
  //         ),

  void showBottomSheet() {
    Scaffold.of(context).showBottomSheet<void>(
      (BuildContext context) {
        return Container(
          height: 175,
          color: Pallete.lightGreyColor,
          child: Row(
            children: [
              Flexible(
                flex: 45,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: const Image(
                        width: double.infinity,
                        height: double.infinity,
                        image: NetworkImage(
                            "https://www.tsinghua.edu.cn/__local/A/83/E4/FAC7A1F5BF79662CCC704BF6076_A6A996EB_3365B.jpg"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Flexible(
                flex: 55,
                child: Container(
                  // color: Colors.blue,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 75,
                        child: Container(
                          color: Colors.greenAccent,
                          child: const Center(
                            child: Text("球场基础信息"),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 25,
                        child: Container(
                          // color: Colors.redAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () => {},
                                child: Text("新赛事"),
                              ),
                              TextButton(
                                onPressed: openCourtProfileView,
                                child: Text("球场信息"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleMapTap(TapPosition tapPosition, LatLng latlng) {
    print(latlng);
    print(mapController.zoom);
  }

  void openCourtProfileView() {
    Navigator.push(context, CourtProfileView.route());
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(
        width: 40,
        height: 40,
        point: LatLng(currentPosition.latitude, currentPosition.longitude),
        builder: (ctx) => SvgPicture.asset(
          AssetsConstants.courtFinderLogo,
        ),
      ),
      Marker(
        width: 40,
        height: 40,
        point: LatLng(40.008406, 116.324643),
        builder: (ctx) => InkWell(
          onTap: () => showBottomSheet(),
          child: SvgPicture.asset(
            AssetsConstants.courtFinderLogo2,
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          AssetsConstants.courtFinderLogo,
          height: 50,
        ),
        centerTitle: true,
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  color: Colors.amber,
                  width: double.infinity,
                  height: double.infinity,
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: currentPosition != null ? LatLng(40.008406, 116.324643) : LatLng(51.5, -0.09),
                      zoom: 15,
                      maxZoom: MapConstants.maxZoom,
                      minZoom: MapConstants.minZoom,
                      interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      onTap: (tapPosition, point) => handleMapTap(tapPosition, point),
                    ),
                    nonRotatedChildren: [],
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                      ),
                      MarkerLayer(markers: markers)
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  width: double.infinity,
                  height: 35,
                  // color: Colors.blue,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center, // 垂直方向居中
                    children: [
                      Flexible(
                        flex: 76,
                        child: Container(
                          // color: Colors.yellow,
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(color: Pallete.blackColor),
                            onSubmitted: (value) {
                              print("search $value");
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(1).copyWith(
                                left: 20,
                              ),
                              fillColor: Pallete.lightGreyColor,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(color: Pallete.blackColor, width: 2),
                              ),
                              hintText: 'Search Courts',
                              hintStyle: const TextStyle(color: Pallete.blackColor, fontSize: 12),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(color: Pallete.blackColor, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(flex: 2, child: Container()),
                      Flexible(
                        flex: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Pallete.lightGreyColor,
                          ),
                          // color: Pallete.lightGreyColor,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                isLivePosition == true ? Icons.location_on : Icons.location_off,
                                size: 15,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                // showBottomSheet();
                                turnLiveOnOff();
                              },
                            ),
                          ),
                        ),
                      ),
                      Flexible(flex: 2, child: Container()),
                      Flexible(
                        flex: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Pallete.lightGreyColor,
                          ),
                          // color: Pallete.lightGreyColor,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.my_location,
                                size: 15,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                mapController.move(LatLng(currentPosition.latitude, currentPosition.longitude), 16.87);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: Container(
                    color: Pallete.lightGreyColor,
                    child: Text(
                      currentPosition == null ? '(0,0)' : '(${currentPosition.longitude}, ${currentPosition.latitude})',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

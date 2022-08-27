import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> latitudeLongitude = [

  const LatLng(31.5925, 74.3095),
  const LatLng(31.5566, 74.3263),
  const LatLng(31.4914, 74.2385),
];

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

String lat = "31.975697";
String lng = "35.859400";

class _MapScreenState extends State<MapScreen> {
  final _formKey = GlobalKey<FormState>();

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(30.3753, 69.3451),
    zoom: 11.5,
  );
  @override
  void dispose() {
    _googleMapController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  late GoogleMapController _googleMapController;

  final Set<Marker> markers = Set(); //markers for google map
    Future<Position> getUserCurrentLocation()async{
      await Geolocator.requestPermission().then((value) {

      }).onError((error, stackTrace) {
        print("error"+error.toString());
      });
      return await Geolocator.getCurrentPosition();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 65,
        title: const Text(
          "SLIMS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 30,
              color: Colors.white,
            )),

      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              alignment: Alignment.center,
              child: GoogleMap(
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: latitudeLongitude[0],
                  zoom: 15.151926040649414,
                ),
                markers: getmarkers(),
                onMapCreated: (controller) => _googleMapController = controller,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.transparent,
                height: 120,
                child: PageView.builder(
                  itemBuilder: buildListItem,
                  itemCount: latitudeLongitude.length,
                  onPageChanged: (val) {
                    moveToLocation(val);
                    print(val);
                  },
                ),
              ),
            ))
          ],
        ),
      ),

    );
  }

  Set<Marker> getmarkers() {
    for (int i = 0; i < latitudeLongitude.length; i++) {
      markers.add(Marker(
        //add second marker
        markerId: MarkerId('$i'),
        position: latitudeLongitude[i],
        icon: BitmapDescriptor.defaultMarker,
      ));
    }
    setState(() {});

    return markers;
  }

  moveToLocation(int index) {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: latitudeLongitude[index], zoom: 15.151926040649414),
    ));
  }

  Widget buildListItem(BuildContext context, int index) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Center(
              child: Padding(
                padding:  const EdgeInsets.all(8),
                child: Container(
                  height: 100,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "images/food.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                  title:  Text(
                    "Eastren Food",
                    style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(
                        Icons.fmd_good_outlined,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      Expanded(

                        child: const Text(
                          "4c9r+48w,Janat Pura Kasur,Punjab",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
        elevation: 8,
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}

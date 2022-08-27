import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';


var curentposition;

class UserLocation extends GetxController {
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  locationpermision() async {
    getUserCurrentLocation().then((value) async {

      print('my current location');
      print(value.latitude.toString() + " " + value.longitude.toString());
      curentposition =
          value.latitude.toString() + " " + value.longitude.toString();
      FirebaseFirestore.instance
          .collection('coordenates')
          .doc('063U10wKMUs5RTzA8f3i')
          .update({"longitude": value.longitude, "latitude": value.latitude});
    }
    );
  }
}

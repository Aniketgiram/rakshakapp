import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:rakshak/services/User_Location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location_permissions/location_permissions.dart';

class locationService {
  UserLocation _currentLocation;
  var location = Geolocator();

  Future<UserLocation> getLocation() async {
    if (Platform.isIOS) {
      location.getLastKnownPosition().then((value) async {
        if (value == null) {
          try {
            var userlocation = await location.getCurrentPosition();
            _currentLocation = UserLocation(
                latitude: userlocation.latitude,
                longitude: userlocation.longitude);
            saveLocationData(userlocation.latitude, userlocation.longitude);
          } on PlatformException catch (e) {
            print("Error catch");
            if (e.code == "PERMISSION_DENIED") {
              print("solving err");
              var userlocation = await location.getLastKnownPosition(
                  desiredAccuracy: LocationAccuracy.high);
              _currentLocation = UserLocation(
                  latitude: userlocation.latitude,
                  longitude: userlocation.longitude);
              saveLocationData(userlocation.latitude, userlocation.longitude);
            } else {
              print("Could Not get the location -> $e");
            }
          } catch (e) {
            print("Could Not get the location -> $e");
          }
        } else {
          _currentLocation = UserLocation(
              latitude: value.latitude, longitude: value.longitude);
          saveLocationData(value.latitude, value.longitude);
        }
      }).catchError((e){
        print("Could Not get the location -> $e");
      });
    } else if (Platform.isAndroid) {
      try {
        var userlocation = await location.getCurrentPosition();
        _currentLocation = UserLocation(
            latitude: userlocation.latitude, longitude: userlocation.longitude);
        saveLocationData(userlocation.latitude, userlocation.longitude);
      } on PlatformException catch (e) {
        print("Error catch");
        if (e.code == "PERMISSION_DENIED") {
          print("solving err");
          var userlocation = await location.getLastKnownPosition(
              desiredAccuracy: LocationAccuracy.high);
          _currentLocation = UserLocation(
              latitude: userlocation.latitude,
              longitude: userlocation.longitude);
          saveLocationData(userlocation.latitude, userlocation.longitude);
        } else {
          print("Could Not get the location -> $e");
        }
      } catch (e) {
        print("Could Not get the location -> $e");
      }
    }

    return _currentLocation;
  }

  saveLocationData(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("isFirstTimeLocation")) {
      prefs.setDouble("latitude", latitude);
      prefs.setDouble("longitude", longitude);
      prefs.setBool("isFirstTimeLocation", true);
    }
  }

  Future<Map> FetchLocationData() async {
    Map data = Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data["latitude"] = prefs.getDouble("latitude");
    data["longitude"] = prefs.getDouble("longitude");
    return data;
  }

  checkData() {
    getLocation().then((geoData) {
      FetchLocationData().then((sharedData) {
        distanceInMeterCheck(geoData.latitude, geoData.longitude,
            sharedData["latitude"], sharedData["longitude"]);
      });
    });
  }

  distanceInMeterCheck(lat1, long1, lat2, long2) async {
    double distanceInMeters =
        await Geolocator().distanceBetween(lat1, long1, lat2, long2);
    if (distanceInMeters > 0 && distanceInMeters <= 2000) {
      print("ok");
    } else {
      print("flag");
      updateFlag();
    }
  }

  checkLocationData() {
    const time = const Duration(minutes: 2);
    Timer.periodic(time, (Timer t) => checkPermission());
  }

  updateFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("phoneno")) {
      var no = prefs.getString("phoneno");
      Firestore.instance
          .collection('users')
          .document("$no")
          .updateData({'flag': true});
      return true;
    } else {
      return false;
    }
  }

  checkPermission() async {
    print("In Checkpermission");

    if (Platform.isAndroid) {
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus();
      if (geolocationStatus == GeolocationStatus.granted) {
        print("granted");
        checkData();
      } else if (geolocationStatus == GeolocationStatus.denied) {
        print("denied");

        Geolocator()..forceAndroidLocationManager = true;
        PermissionStatus permission =
            await LocationPermissions().requestPermissions();
        if (permission == PermissionStatus.denied) {
          LocationPermissions().openAppSettings();
        } else if (permission == PermissionStatus.granted) {
          checkData();
        }
      } else if (geolocationStatus == GeolocationStatus.disabled) {
        print("disabled");
        Geolocator()..forceAndroidLocationManager = true;
        PermissionStatus permission =
            await LocationPermissions().requestPermissions();
        if (permission == PermissionStatus.denied) {
          LocationPermissions().openAppSettings();
        } else if (permission == PermissionStatus.granted) {
          checkData();
        }
      } else if (geolocationStatus == GeolocationStatus.restricted) {
        print("restricted");
        Geolocator()..forceAndroidLocationManager = true;
        PermissionStatus permission =
            await LocationPermissions().requestPermissions();
        if (permission == PermissionStatus.denied) {
          LocationPermissions().openAppSettings();
        } else if (permission == PermissionStatus.granted) {
          checkData();
        }
      }
    } else if (Platform.isIOS) {
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus();
      if (geolocationStatus == GeolocationStatus.granted) {
        checkData();
      } else if (geolocationStatus == GeolocationStatus.denied) {
        print("denied");
        PermissionStatus permission =
            await LocationPermissions().requestPermissions();
        if (permission == PermissionStatus.denied) {
          LocationPermissions().openAppSettings();
        } else if (permission == PermissionStatus.granted) {
          checkData();
        }
      } else if (geolocationStatus == GeolocationStatus.disabled) {
        print("disabled");
        PermissionStatus permission =
            await LocationPermissions().requestPermissions();
        if (permission == PermissionStatus.denied) {
          LocationPermissions().openAppSettings();
        } else if (permission == PermissionStatus.granted) {
          checkData();
        }
      } else if (geolocationStatus == GeolocationStatus.restricted) {
        print("restricted");
        PermissionStatus permission =
            await LocationPermissions().requestPermissions();
        if (permission == PermissionStatus.denied) {
          LocationPermissions().openAppSettings();
        } else if (permission == PermissionStatus.granted) {
          checkData();
        }
      } else if (geolocationStatus == GeolocationStatus.unknown) {
        print("unknown");
        PermissionStatus permission =
            await LocationPermissions().requestPermissions();
        if (permission == PermissionStatus.denied) {
          LocationPermissions().openAppSettings();
        } else if (permission == PermissionStatus.granted) {
          checkData();
        }
      }
    }
  }
}

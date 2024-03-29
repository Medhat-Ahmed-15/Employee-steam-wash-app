import 'package:employee_steam_wash_app/key.dart';
import 'package:employee_steam_wash_app/models/address.dart';
import 'package:employee_steam_wash_app/models/directdetails.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressDataProvider extends ChangeNotifier {
  Address currentLocation;
  Address destinationLocation;

//updating current user Location  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  void updateCurrentLocationAddress(Address pickUpAddress) {
    currentLocation = pickUpAddress;
    notifyListeners();
  }

//updating destination Location  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  void updateDestinationLocationAddress(Address destinationLocationAddress) {
    destinationLocation = destinationLocationAddress;
    notifyListeners();
  }
//Sending to this method any url to handle it and return the result  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<dynamic> getRequest(String url) async {
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      } else {
        return "failed";
      }
    } catch (exp) {
      return "failed";
    }
  }

// Converting My Current address which contains of latitude and longitude to readable address I can understand  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<String> convertToReadableAddress(Position position) async {
    String placeAddress = "";

    String placeAddress1;
    String placeAddress2;
    String placeAddress3;
    String placeAddress4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

    var response = await getRequest(url);

    if (response != "failed") {
      // placeAddress = response["results"][0][
      //     "formatted_address"]; //since the formatted address displays the specific address of the current location and this is risky regarding the security
      placeAddress1 =
          response["results"][0]["address_components"][0]["long_name"];
      placeAddress2 =
          response["results"][0]["address_components"][2]["long_name"];
      placeAddress4 =
          response["results"][0]["address_components"][3]["long_name"];

      placeAddress =
          placeAddress1 + ", " + placeAddress2 + ", " + placeAddress4;

      Address userCurrentAddress = new Address();
      userCurrentAddress.longitude = position.longitude;
      userCurrentAddress.latitude = position.latitude;
      userCurrentAddress.placeName = placeAddress;

      updateCurrentLocationAddress(userCurrentAddress);
    }
    return placeAddress;
  }

//obtaining information details between initial adress and destination address >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<DirectionDetails> obtainPlaceDirectionDetailsBetweenTwoPoints(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.longitude},${initialPosition.latitude}&destination=${finalPosition.longitude},${finalPosition.latitude}&key=$apiKey';

    var res = await getRequest(directionUrl);

    if (res == 'failed') {
      return null;
    }

    DirectionDetails directiondetails = DirectionDetails();

    directiondetails.encodedPoints =
        //the encoded points of the line which will be translated on map.
        res['routes'][0]['overview_polyline']['points'];

    directiondetails.distanceText =
        res['routes'][0]['legs'][0]['distance']['text'];

    directiondetails.distancevalue =
        res['routes'][0]['legs'][0]['distance']['value'];

    directiondetails.durationText =
        res['routes'][0]['legs'][0]['duration']['text'];

    directiondetails.durationValue =
        res['routes'][0]['legs'][0]['duration']['value'];

    return directiondetails;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:state_management/models/trip.dart';

class TripProvider {
  Future<String> _loadTripsAsset() async {
    return await rootBundle.loadString('assets/trips.json');
  }

  Future<List<Trip>> getTripList() async {
    try {
      String jsonString = await _loadTripsAsset();

      //Convert string to json Object
      var jsonResponse = jsonDecode(jsonString);

      //convert Json Object to Trip (List of trips)
      return (jsonResponse as List).map((e) => Trip.fromJson(e)).toList();
    } on Exception catch (e) {
      stderr.writeln(e);
      throw e;
    }
  }
}

import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:state_management/api/trip_provider.dart';
import 'package:state_management/models/trip.dart';
import 'package:state_management/repositories/trip_repository.dart';

class TripBloc {
  final TripProvider _tripProvider = TripProvider();
  final TripRepository _tripRepository = TripRepository();
  PublishSubject<List<Trip>> _tripListPublishSubject =
      PublishSubject<List<Trip>>();

  Future<void> getTripList() async {
    try {
      List<Trip> tripList = await _tripProvider.getTripList();
      _tripRepository.tripList = tripList;
      _tripListPublishSubject.sink.add(_tripRepository.tripList);
    } on Exception catch (e) {
      stderr.writeln(e);
    }
  }

  dispose() {
    _tripListPublishSubject.close();
  }

  PublishSubject<List<Trip>> get tripListPublishSubject =>
      _tripListPublishSubject;
}

var tripBloc = TripBloc();

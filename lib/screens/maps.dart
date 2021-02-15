import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'kiosks.dart';

class maps extends StatefulWidget {
  static const String id = 'maps';
  @override
  _mapsState createState() => _mapsState();
}

class _mapsState extends State<maps> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  List<Marker> barncafemarkers = [];
  List<Marker> cyancafemarkers = [];

  String selectedcafe = kiosks.selectedkiosk;

  LatLng selectedlatlng;

  String latestMarkerValue;
  LatLng latestmarkerlocation;

  List<LatLng> barncafe = List<LatLng>();
  List<String> barncafenames = ['barncafe1', 'barncafe2', 'barncafe3'];

  List<LatLng> cyancafe = List<LatLng>();
  List<String> cyancafenames = ['cyan1', 'cyan2', 'cyan3'];

  showAlertDialog(String s) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("confrim"),
      onPressed: () {
        //nav
        Navigator.pushNamed(context, kiosks.id);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like choose ($s) branch? "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void initState() {
    super.initState();
    // barn cafes branches array
    barncafe.add(LatLng(21.680401, 39.211323));
    barncafe.add(LatLng(21.764920, 39.121150));
    barncafe.add(LatLng(21.699860, 39.111187));

    // cyan cafes branches array
    cyancafe.add(LatLng(21.628069, 39.104659));
    cyancafe.add(LatLng(21.594874, 39.245172));
    cyancafe.add(LatLng(21.575719, 39.164094));

    //////////////////////////////////////////////////////////

    barncafemarkers.add(Marker(
      markerId: MarkerId(barncafenames[0]),
      draggable: false,
      position: barncafe[0],
      onTap: () {
        showAlertDialog(barncafenames[0]);
        latestMarkerValue = barncafenames[0];
        latestmarkerlocation =
            LatLng(barncafe[0].latitude, barncafe[0].longitude);

        //Navigator.push(
        //context,
        //MaterialPageRoute(builder: (context) => SecondRoute()),
        //);
        print(latestMarkerValue);
        print(latestmarkerlocation.longitude);
        print(latestmarkerlocation.latitude);
      },
    ));
    barncafemarkers.add(Marker(
      markerId: MarkerId(barncafenames[1]),
      draggable: false,
      position: barncafe[1],
      onTap: () {
        latestMarkerValue = barncafenames[1];
        latestmarkerlocation =
            LatLng(barncafe[1].latitude, barncafe[1].longitude);
        print(latestMarkerValue);
        print(latestmarkerlocation.longitude);
        print(latestmarkerlocation.latitude);
      },
    ));
    barncafemarkers.add(Marker(
      markerId: MarkerId(barncafenames[2]),
      draggable: false,
      position: barncafe[2],
      onTap: () {
        latestMarkerValue = barncafenames[2];
        latestmarkerlocation =
            LatLng(barncafe[2].latitude, barncafe[2].longitude);

        print(latestMarkerValue);
        print(latestmarkerlocation.longitude);
        print(latestmarkerlocation.latitude);
      },
    ));

    //////////////////////////////////////////////////////////

    cyancafemarkers.add(Marker(
      markerId: MarkerId(cyancafenames[0]),
      draggable: false,
      position: cyancafe[0],
      onTap: () {
        latestMarkerValue = cyancafenames[0];
        latestmarkerlocation =
            LatLng(cyancafe[0].latitude, cyancafe[0].longitude);
        print(latestMarkerValue);
        print(latestmarkerlocation.longitude);
        print(latestmarkerlocation.latitude);
      },
    ));
    cyancafemarkers.add(Marker(
      markerId: MarkerId(cyancafenames[1]),
      draggable: false,
      position: cyancafe[1],
      onTap: () {
        latestMarkerValue = cyancafenames[1];
        latestmarkerlocation =
            LatLng(cyancafe[1].latitude, cyancafe[1].longitude);
        print(latestMarkerValue);
        print(latestmarkerlocation.longitude);
        print(latestmarkerlocation.latitude);
      },
    ));
    cyancafemarkers.add(Marker(
      markerId: MarkerId(cyancafenames[2]),
      draggable: false,
      position: cyancafe[2],
      onTap: () {
        latestMarkerValue = cyancafenames[2];
        latestmarkerlocation =
            LatLng(cyancafe[2].latitude, cyancafe[2].longitude);
        print(latestMarkerValue);
        print(latestmarkerlocation.longitude);
        print(latestmarkerlocation.latitude);
      },
    ));
  }

  Position currentPoistion;
  LatLng latlng;

  List<Marker> check(String selectedcafe) {
    if (selectedcafe == "barncafemarkers") {
      return barncafemarkers;
    } else if (selectedcafe == "cyancafemarkers") {
      return cyancafemarkers;
    }
  }

  void locatePosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPoistion = position;
    latlng = LatLng(currentPoistion.latitude, currentPoistion.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latlng, zoom: 15);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  LatLng inital = LatLng(21.582104, 39.185093);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: inital, zoom: 10),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controllerGoogleMap.complete(controller);
          newGoogleMapController = controller;
          locatePosition();
        },
        markers: Set.from(check(selectedcafe)),
      ),
    );
  }
}

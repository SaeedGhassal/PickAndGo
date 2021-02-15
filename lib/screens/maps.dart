import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'kiosks.dart';

final _firestore = Firestore.instance;

class maps extends StatefulWidget {
  static const String id = 'maps';
  @override
  _mapsState createState() => _mapsState();
}

class _mapsState extends State<maps> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  bool mapToggle = false;
  var currentLocation;
  List<Marker> allMarkers = [];
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        getmarkers();
      });
    });
  }

  getmarkers() {
    _firestore.collection('BarnLocation').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          initMarker(docs.documents[i].data);
        }
      }
    });
  }

  String latestMarkerValue;
  initMarker(branch) {
    allMarkers.add(Marker(
      position:
          LatLng(branch['location'].latitude, branch['location'].longitude),
      draggable: false,
      markerId: MarkerId(branch['BranchName']),
      infoWindow: InfoWindow(title: 'Barns', snippet: branch['BranchName']),
      onTap: () {},
    ));
  }

  Position currentPoistion;
  LatLng latlng;

  void locatePosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPoistion = position;
    latlng = LatLng(currentPoistion.latitude, currentPoistion.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latlng, zoom: 11);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height - 80.0,
                  width: double.infinity,
                  child: mapToggle
                      ? GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(21.582104, 39.185093), zoom: 11),
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          onMapCreated: onMapCreated,
                          markers: Set.from(allMarkers),
                        )
                      : Center(
                          child: Text(
                            'Map is loading please wait',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )),
            ],
          ),
        ],
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      newGoogleMapController = controller;
    });
  }
}

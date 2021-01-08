//region Core
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/app_urls.dart';
import 'package:gps_tracker_mobile/core/constants/enums/status_code.dart';
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
//endregion

//region Models
import 'package:gps_tracker_mobile/models/tracker_model.dart';
//endregion

Future<TrackerModel> _getTrackers(String accessToken, String deviceId, String customerId, String token, int id) async {

  var response = await http.get("${AppUrls.customer}/1/device/1/tracker",
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok) {
    
    Map<String, dynamic> decodeJson = json.decode(response.body);
    TrackerModel tracker = TrackerModel.fromJson(decodeJson);

    return tracker;

  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

class TrackerPage extends StatefulWidget {

  final int id;
  final String title;

  TrackerPage({Key key, @required this.id, @required this.title}) : super(key: key);

  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {

  Future<TrackerModel> _trackerData;

  SharedPreferences _sharedPreferences;

  String _accessToken, _customerId, _deviceId, _token;

  final List<LatLng> _points = <LatLng>[];

  @override
  void initState() {

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      //_customerId = _sharedPreferences.getString(StorageKey.customerId);
      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      var tracker = _getTrackers(_accessToken, _deviceId, _customerId, _token, widget.id);

      tracker.then((value) => {
        value.data.forEach((element) {
          _points.add(LatLng(double.parse(element.latitude), double.parse(element.longitude)));
        })
      });

      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;

  void _add() {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.red,
      width: 5,
      points: _points,
    );

    setState(() {
      _mapPolylines[polylineId] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: _appBarTitle(),
        ),
        body:
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.09776, 34.47393),
            zoom: 5,
          ),
          polylines: Set<Polyline>.of(_mapPolylines.values),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _add,
          label: Text('Verileri Getir'),
          icon: Icon(Icons.map),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _appBarTitle() {
    return Text(
      widget.title,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Colors.black,
      ),
    );
  }
}

//region Core
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracker_mobile/pages/member/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/app_urls.dart';
import 'package:gps_tracker_mobile/core/constants/enums/status_code.dart';
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
//endregion

//region Page
import 'package:gps_tracker_mobile/pages/tracker.dart';
//endregion

//region Models
import 'package:gps_tracker_mobile/models/device_model.dart';
//endregion

Future<DeviceModel> _getDevices(String accessToken, String deviceId, String token) async {

  var url = "${AppUrls.customer}/1/device";

  var response = await http.get(url,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    DeviceModel categories = DeviceModel.fromJson(decodeJson);

    return categories;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key key}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {

  Future<DeviceModel> _devicesData;

  SharedPreferences _sharedPreferences;

  String _accessToken, _deviceId, _token;

  bool _isLogin;

  @override
  void initState() {

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      _devicesData = _getDevices(_accessToken, _deviceId, _token);

      _isLogin = _sharedPreferences.getBool(StorageKey.isLogin) != null ? _sharedPreferences.getBool(StorageKey.isLogin) : false;

      if (!_isLogin) {
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginPage()));
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Cihazlarım", style: TextStyle(fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,),
        ),
      ),
      body: Column(
        children: <Widget>[
          _devices()
        ],
      ),
    );
  }

  Expanded _devices() {
    return Expanded(
      child: FutureBuilder(future: _devicesData, builder: (BuildContext context, AsyncSnapshot<DeviceModel> snapshot){
        if(snapshot.hasData){
          return ListView.builder(itemCount: snapshot.data.data.length, itemBuilder: (BuildContext context, index){
            return ListTile(
              title: Text(snapshot.data.data[index].title),
              leading: CircleAvatar(child: Text(snapshot.data.data[index].title.toString()[0]),),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                setState(() {
                  pushNewScreen(context, screen: TrackerPage(id: snapshot.data.data[index].id, title: snapshot.data.data[index].title));
                });
              },
            );
          });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
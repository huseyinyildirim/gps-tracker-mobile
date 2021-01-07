//region Core
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
import 'package:gps_tracker_mobile/core/constants/app_urls.dart';
import 'package:gps_tracker_mobile/core/constants/enums/status_code.dart';
import 'package:gps_tracker_mobile/core/constants/app_strings.dart';
//endregion

//region Page
//endregion

//region Widgets
//endregion

//region Models
import 'package:gps_tracker_mobile/models/billing_address_model.dart';
import 'package:gps_tracker_mobile/models/delivery_address_model.dart';
//endregion

Future<BillingAddressModel> _getBillingAddress(String accessToken, String deviceId, String token) async {

  var response = await http.get(AppUrls.billingAddress,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    BillingAddressModel billingAddress = BillingAddressModel.fromJson(decodeJson);

    return billingAddress;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<DeliveryAddressModel> _getDeliveryAddress(String accessToken, String deviceId, String token) async {

  var response = await http.get(AppUrls.deliveryAddress,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    DeliveryAddressModel deliveryAddress = DeliveryAddressModel.fromJson(decodeJson);

    return deliveryAddress;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

class AccountAddressPage extends StatefulWidget {

  const AccountAddressPage({Key key}) : super(key: key);

  @override
  _AccountAddressPageState createState() => _AccountAddressPageState();
}

class _AccountAddressPageState extends State<AccountAddressPage> {

  Future<DeliveryAddressModel> _deliveryAddressData;
  Future<BillingAddressModel> _billingAddressData;

  SharedPreferences _sharedPreferences;

  String _accessToken, _deviceId, _token;

  String _deliveryAddressId;
  String _billingAddressId;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      _deliveryAddressData = _getDeliveryAddress(_accessToken, _deviceId, _token);
      _billingAddressData = _getBillingAddress(_accessToken, _deviceId, _token);

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
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.deepOrange,),
            onPressed: () {
              setState(() {
                _deliveryAddressData = _getDeliveryAddress(_accessToken, _deviceId, _token);
                _billingAddressData = _getBillingAddress(_accessToken, _deviceId, _token);
              });
            },
          )
        ],
        title: Text("Adresleriniz", style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black,),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ListView(
      padding: EdgeInsets.only(left: 10, right: 10),
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.local_shipping, color: Colors.black38,),
            SizedBox(width: 10,),
            Text("Teslimat Adresleriniz", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38),)
          ],
        ),
        _deliveryAddressList(),
        SizedBox(height: 20,),
        Row(
          children: <Widget>[
            Icon(Icons.description, color: Colors.black38,),
            SizedBox(width: 10,),
            Text("Fatura Adresleriniz", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38),)
          ],
        ),
        _billingAddressList(),
        SizedBox(height: 20,),
      ],
    );
  }

  Widget _deliveryAddressList() {
    return FutureBuilder(future: _deliveryAddressData, builder: (BuildContext context, AsyncSnapshot<DeliveryAddressModel> snapshot){
      if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
        return ListView.builder(shrinkWrap: true, primary: false, itemCount: snapshot.data.data.length, itemBuilder: (BuildContext context, index){
          return Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Radio(
                      value: snapshot.data.data[index].guid,
                      groupValue: _deliveryAddressId,
                      onChanged: (value) {
                        setState(() {
                          _deliveryAddressId = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(child: Text(snapshot.data.data[index].alias, style: TextStyle(fontWeight: FontWeight.bold),)),
                            Expanded(child: Text("Düzenle", textAlign: TextAlign.right, style: TextStyle(color: Colors.redAccent[700]),)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text("${snapshot.data.data[index].address} ${snapshot.data.data[index].town.title}/${snapshot.data.data[index].city.title}/${snapshot.data.data[index].country.title}"),
                        SizedBox(height: 10,),
                        Text("${snapshot.data.data[index].name} ${snapshot.data.data[index].surname} (${snapshot.data.data[index].identityNo})"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
        return Padding(padding: EdgeInsets.only(top: 10), child: Text(AppStrings.notDeliveryAddress),);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _billingAddressList() {
    return FutureBuilder(future: _billingAddressData, builder: (BuildContext context, AsyncSnapshot<BillingAddressModel> snapshot){
      if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
        return ListView.builder(shrinkWrap: true, primary: false, itemCount: snapshot.data.data.length, itemBuilder: (BuildContext context, index){
          return Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Radio(
                      value: snapshot.data.data[index].guid,
                      groupValue: _billingAddressId,
                      onChanged: (value) {
                        setState(() {
                          _billingAddressId = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(child: Text(snapshot.data.data[index].alias, style: TextStyle(fontWeight: FontWeight.bold),)),
                            Expanded(child: Text("Düzenle", textAlign: TextAlign.right, style: TextStyle(color: Colors.redAccent[700]),)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text("${snapshot.data.data[index].address} ${snapshot.data.data[index].town.title}/${snapshot.data.data[index].city.title}/${snapshot.data.data[index].country.title}"),
                        SizedBox(height: 10,),
                        Text("${snapshot.data.data[index].name} ${snapshot.data.data[index].surname} (${snapshot.data.data[index].identityNo})"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
        return Padding(padding: EdgeInsets.only(top: 10), child: Text(AppStrings.notBillingAddress),);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
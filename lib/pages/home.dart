//region Core
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/app_urls.dart';
import 'package:gps_tracker_mobile/core/constants/enums/status_code.dart';
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
//endregion

//region Page
import 'package:gps_tracker_mobile/pages/catalog/product.dart';
//endregion

//region Widgets
import 'package:gps_tracker_mobile/core/widgets/star_display.dart';
//endregion

//region Models
import 'package:gps_tracker_mobile/models/sliders_model.dart';
import 'package:gps_tracker_mobile/models/showcase_types_model.dart';
import 'package:gps_tracker_mobile/models/showcases_model.dart';
import 'package:gps_tracker_mobile/models/showcase_products_model.dart';

//endregion

Future<SlidersModel> _getSliders(String accessToken, String deviceId, String token) async {
  var response = await http.get(AppUrls.sliders,
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      }
  );

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    SlidersModel sliders = SlidersModel.fromJson(decodeJson);

    return sliders;

  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<ShowcaseTypesModel> _getShowcaseTypes(String accessToken, String deviceId, String token) async {
  var response = await http.get(AppUrls.showcaseTypes,
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      }
  );

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    ShowcaseTypesModel showcaseTypes = ShowcaseTypesModel.fromJson(decodeJson);

    return showcaseTypes;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<ShowcasesModel> _getShowcases(String accessToken, String deviceId, String token, String showcaseTypeID) async {
  var response = await http.get("${AppUrls.showcaseTypes}/${showcaseTypeID}",
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      }
  );

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    ShowcasesModel showcases = ShowcasesModel.fromJson(decodeJson);

    return showcases;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<ShowcaseProductsModel> _getShowcaseProducts(String accessToken, String deviceId, String token, String showcaseId) async {
  var response = await http.get("${AppUrls.showcaseTypes}/${showcaseId}/products",
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      }
  );

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    ShowcaseProductsModel showcaseProducts = ShowcaseProductsModel.fromJson(decodeJson);

    return showcaseProducts;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

class HomePage extends StatefulWidget {

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _textSearch;

  Future<SlidersModel> _slidersData;
  Future<ShowcaseTypesModel> _showcaseTypesData;

  SharedPreferences _sharedPreferences;

  String _deviceId, _token, _accessToken;

  @override
  void initState() {

    _textSearch = TextEditingController();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      _slidersData = _getSliders(_accessToken, _deviceId, _token);
      _showcaseTypesData = _getShowcaseTypes(_accessToken, _deviceId, _token);

      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _textSearch.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Elit Reyon", style: TextStyle(fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,),
            )
        ),
        body: ListView(children: [
          _searchBar(),
          _slider(),
          _showcaseTypes()
        ])
    );
  }

  Container _showcaseTypes() {
    return Container(
          child: FutureBuilder(future: _showcaseTypesData, builder: (BuildContext context, AsyncSnapshot<ShowcaseTypesModel> snapshot){
            if(snapshot.hasData){
              return ListView.builder(shrinkWrap: true, primary: false, itemCount: snapshot.data.data.length, itemBuilder: (BuildContext context, index){
                if (snapshot.data.data[index].isGroup == "0"){
                  return Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 20), child: Text(snapshot.data.data[index].title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                      Container(
                        child: _showcases(snapshot, index, context),
                      )
                    ],
                  );
                } else {
                  return null;
                }
              });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        );
  }

  FutureBuilder<ShowcasesModel> _showcases(AsyncSnapshot<ShowcaseTypesModel> snapshot, int index, BuildContext context) {
    return FutureBuilder(future: _getShowcases(_accessToken, _deviceId, _token, snapshot.data.data[index].id.toString()), builder: (BuildContext context2, AsyncSnapshot<ShowcasesModel> snapshot2){
      if(snapshot2.hasData){
        return ListView.builder(shrinkWrap: true, primary: false, itemCount: snapshot2.data.data.length, itemBuilder: (BuildContext context2, index2){
          return Container(
            width: double.infinity,
            height: 220,
            child: _showcaseProducts(snapshot2, index2, context),
          );
        });
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }

  FutureBuilder<ShowcaseProductsModel> _showcaseProducts(AsyncSnapshot<ShowcasesModel> snapshot2, int index2, BuildContext context) {
    return FutureBuilder(future: _getShowcaseProducts(_accessToken, _deviceId, _token, snapshot2.data.data[index2].id.toString()), builder: (BuildContext context3, AsyncSnapshot<ShowcaseProductsModel> snapshot3){
      if(snapshot3.hasData){
        return ListView.builder(scrollDirection: Axis.horizontal, primary: false, itemCount: snapshot3.data.data.length, itemBuilder: (BuildContext context3, index3){
          return Container(
            width: MediaQuery.of(context).size.width/2.2,
            child: InkWell(
              onTap: (){
                setState(() {
                  pushNewScreen(context, screen: ProductPage(slug: snapshot3.data.data[index3].slug));
                });
                },
              child: Card(
                elevation: 0,
                margin: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image(
                            image: NetworkImage(AppUrls.base + snapshot3.data.data[index3].image),
                            fit: BoxFit.fitHeight,
                            height: 125,
                          ),
                          Positioned(
                            top: 0,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: (null == snapshot3.data.data[index3].discountRate ? null : Colors.redAccent)
                              ),
                              padding: EdgeInsets.all(4.0),
                              child: Text((null == snapshot3.data.data[index3].discountRate ? "" : "-%" +double.parse(snapshot3.data.data[index3].discountRate).toStringAsFixed(0)),
                                  style: TextStyle(backgroundColor: Colors.red, color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snapshot3.data.data[index3].brand,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text((snapshot3.data.data[index3].score != null ? double.parse(snapshot3.data.data[index3].score).toStringAsFixed(1) : ""),
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blueGrey
                                ),
                              ),
                              IconTheme(
                                data: IconThemeData(
                                  color: Colors.amber,
                                  size: 48,
                                ),
                                child: StarDisplayWidget(value: (snapshot3.data.data[index3].score != null ? int.parse(snapshot3.data.data[index3].score) : 0), size: 15,),
                              )
                            ],
                          ),
                          Text(snapshot3.data.data[index3].title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.left, maxLines: 1, ),
                          Row(
                            children: <Widget>[
                              Text(double.parse(snapshot3.data.data[index3].discountPrice) == 0 ? "${snapshot3.data.data[index3].salePrice} ${snapshot3.data.data[index3].currency}" : "", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 12),),
                              Text(double.parse(snapshot3.data.data[index3].discountPrice) > 0 ? "${snapshot3.data.data[index3].salePrice} ${snapshot3.data.data[index3].currency}" : "", style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 11),),
                              Text(double.parse(snapshot3.data.data[index3].discountPrice) > 0 ? " ${snapshot3.data.data[index3].discountPrice} ${snapshot3.data.data[index3].currency}" : "", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12), ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }

  FutureBuilder<SlidersModel> _slider() {
    return FutureBuilder(future: _slidersData, builder: (BuildContext context, AsyncSnapshot<SlidersModel> snapshot) {
      if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
        return CarouselSlider.builder(
          itemCount: snapshot.data.data.length,
          options: CarouselOptions(
              autoPlay: true,
              height: 200,
              enlargeCenterPage: false,
              aspectRatio: 2.0,
              viewportFraction: 0.9,
              pauseAutoPlayOnTouch: true
          ),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Colors.white),
              child: Image.network(AppUrls.base + snapshot.data.data[index].mobilePath, fit: BoxFit.cover, width: 1000.0,),
            );
            },
        );
      } else {
        //return Center(child: CircularProgressIndicator());
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }
    });
  }

  Container _searchBar() {
    return Container(
          //color: Colors.blueGrey,
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: TextField(
            textInputAction: TextInputAction.done,
            controller: _textSearch,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Ürün, kategori veya marka ara",
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
            ),
          ),
        );
  }
}
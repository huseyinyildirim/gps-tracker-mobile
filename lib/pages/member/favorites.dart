//region Core
import 'dart:io';
import 'dart:ui';
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
import 'package:gps_tracker_mobile/pages/catalog/product.dart';
//endregion

//region Widgets
//endregion

//region Models
import 'package:gps_tracker_mobile/models/empty_model.dart';
import 'package:gps_tracker_mobile/models/favorites_model.dart';
//endregion

Future<FavoritesModel> _getFavorites(String accessToken, String deviceId, String token) async {

  var response = await http.get(AppUrls.favorites,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    FavoritesModel favorites = FavoritesModel.fromJson(decodeJson);

    return favorites;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

class FavoritesPage extends StatefulWidget {

  const FavoritesPage({Key key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  Future<FavoritesModel> _favoritesData;

  SharedPreferences _sharedPreferences;

  String _accessToken, _deviceId, _token;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      _favoritesData = _getFavorites(_accessToken, _deviceId, _token);

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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.deepOrange,),
              onPressed: () {
                setState(() {
                  _favoritesData = _getFavorites(_accessToken, _deviceId, _token);
                });
              },
            )
          ],
          title: Text("Favorileriniz", style: TextStyle(fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,),
          )
      ),
      body: _productList(),
    );
  }

  Widget _productList() {
    return FutureBuilder(future: _favoritesData, builder: (BuildContext context, AsyncSnapshot<FavoritesModel> snapshot) {
      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
        return Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              GridView.count(
                shrinkWrap: true,
                primary: true,
                crossAxisCount: 1,
                childAspectRatio: 3.5,
                children: List.generate(snapshot.data.data.length, (index) {
                  return _productCard(snapshot, index);
                }),
              ),
            ],
          ),
        );
      } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
        return Center(child: Text("Favorilerinize eklenmiş ürün bulunmuyor.", style: TextStyle(fontSize: 19),),);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    );
  }

  Widget _productCard(AsyncSnapshot<FavoritesModel> snapshot, int index) {
    return Card(
      child: Row(
        children: <Widget>[
          _productCardImage(snapshot, index),
          _productCardDetail(snapshot, index),
          _productCardAddToCart(snapshot, index)
        ],
      ),
    );
  }

  Widget _productCardAddToCart(AsyncSnapshot<FavoritesModel> snapshot, int index) {
    return Container(
      width: MediaQuery.of(context).size.width / 6,
      alignment: Alignment.centerRight,
      child: Column(
          children: <Widget>[
            IconButton(
              color: Colors.deepOrangeAccent,
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () => _addToCart(snapshot.data.data[index].productId),
            ),
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.delete),
              onPressed: () => _delete(snapshot.data.data[index].productId),
            )
          ],
      ),
    );
  }

  Widget _productCardDetail(AsyncSnapshot<FavoritesModel> snapshot, int index) {
    return InkWell(
      onTap: () => pushNewScreen(context, screen: ProductPage(slug: snapshot.data.data[index].slug)),
      child:Container(
        width: MediaQuery.of(context).size.width/1.8,
        padding: EdgeInsets.only(top: 10, left: 5, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(snapshot.data.data[index].title, style: TextStyle(fontWeight: FontWeight.bold),),
            Text("Satıcı: ${snapshot.data.data[index].companyTitle}",),
            SizedBox(height: 7,),
            Text(snapshot.data.data[index].oldPrice != null ? "${snapshot.data.data[index].oldPrice} ${snapshot.data.data[index].symbol}" : "", style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough,),),
            SizedBox(height: 7,),
            Text("${snapshot.data.data[index].price} ${snapshot.data.data[index].symbol}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepOrange),),
          ],
        ),
      ),
    );
  }

  Widget _productCardImage(AsyncSnapshot<FavoritesModel> snapshot, int index) {
    return InkWell(
      onTap: () => pushNewScreen(context, screen: ProductPage(slug: snapshot.data.data[index].slug)),
      child: Container(
        width: MediaQuery.of(context).size.width/5,
        padding: EdgeInsets.only(top: 10, left: 5, bottom: 10),
        child: Image(image: NetworkImage(AppUrls.base + snapshot.data.data[index].image), fit: BoxFit.fitHeight,),
      ),
    );
  }

  _addToCart(String productId) async {

    var response = await http.post("${AppUrls.cart}/${productId.toString()}",
        body: <String, String>{
          "quantity" : "1"
        },
        headers: <String, String>{
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer ${_accessToken}",
          'X-DEVICE-ID': _deviceId,
          'X-TOKEN': _token
        }
    );

    if (response.statusCode == StatusCode.ok) {
      Map<String, dynamic> decodeJson = json.decode(response.body);
      EmptyModel empty = EmptyModel.fromJson(decodeJson);

      _delete(productId);

      showDialog(
        context: context,
        child: AlertDialog(
          title: new Text("Bilgi"),
          content: new Text(AppStrings.productAddedToCart),
          actions: <Widget>[
            FlatButton(
              child: Text('Kapat'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          title: new Text("Bilgi"),
          content: new Text("${AppStrings.generalError} ${AppStrings.tryAgain}"),
          actions: <Widget>[
            FlatButton(
              child: Text('Kapat'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      );
    }

  }

  _delete(String productId) async {

    var response = await http.delete("${AppUrls.favorites}/${productId.toString()}",
        headers: <String, String>{
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer ${_accessToken}",
          'X-DEVICE-ID': _deviceId,
          'X-TOKEN': _token
        }
    );

    if (response.statusCode == StatusCode.ok) {

      setState(() {
        _favoritesData = _getFavorites(_accessToken, _deviceId, _token);
      });

      Map<String, dynamic> decodeJson = json.decode(response.body);
      EmptyModel empty = EmptyModel.fromJson(decodeJson);

      /*showDialog(
        context: context,
        child: AlertDialog(
          title: new Text("Bilgi"),
          content: new Text("Favorilerinizden ürün kaldırılmıştır."),
          actions: <Widget>[
            FlatButton(
              child: Text('Kapat'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      );*/

    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          title: new Text("Bilgi"),
          content: new Text("${AppStrings.generalError} ${AppStrings.tryAgain}"),
          actions: <Widget>[
            FlatButton(
              child: Text('Kapat'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      );
    }

  }
}
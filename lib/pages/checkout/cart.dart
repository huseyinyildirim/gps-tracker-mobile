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
import 'package:gps_tracker_mobile/pages/catalog/product.dart';
import 'package:gps_tracker_mobile/pages/checkout/address.dart';
//endregion

//region Widgets
//endregion

//region Models
import 'package:gps_tracker_mobile/models/cart_model.dart';
import 'package:gps_tracker_mobile/models/cart_totals_model.dart';
import 'package:gps_tracker_mobile/models/empty_model.dart';
//endregion

Future<CartTotalsModel> _getCartTotals(String accessToken, String deviceId, String token) async {

  var response = await http.get(AppUrls.cartTotals,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    CartTotalsModel cartTotals = CartTotalsModel.fromJson(decodeJson);

    return cartTotals;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<CartModel> _getCart(String accessToken, String deviceId, String token) async {

  var response = await http.get(AppUrls.cart,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    CartModel carts = CartModel.fromJson(decodeJson);

    return carts;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

class CartPage extends StatefulWidget {

  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  Future<CartModel> _cartData;
  Future<CartTotalsModel> _cartTotalsData;

  SharedPreferences _sharedPreferences;

  String _accessToken, _deviceId, _token;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      _cartData = _getCart(_accessToken, _deviceId, _token);
      _cartTotalsData = _getCartTotals(_accessToken, _deviceId, _token);

      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                  _cartData = _getCart(_accessToken, _deviceId, _token);
                });
              },
            )
          ],
          title: Text("Sepetiniz", style: TextStyle(fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,),
          )
      ),
      body: _productList(),
    );
  }

  Widget _productList() {
    return FutureBuilder(future: _cartData, builder: (BuildContext context, AsyncSnapshot<CartModel> snapshot) {
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
                _cartTotals(),
                _checkoutButton(),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
          return Center(child: Text("Sepetinize eklenmiş ürün bulunmuyor.", style: TextStyle(fontSize: 19),),);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _cartTotals() {
    return FutureBuilder(future: _cartTotalsData,
      builder: (BuildContext context, AsyncSnapshot<CartTotalsModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(child: Text('Ürün Toplamı', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),)),
                        Expanded(child: Text("${snapshot.data.data.subtotal} ${snapshot.data.data.currency}", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(child: Text('Kargo Bedeli', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),)),
                        Expanded(child: Text("${snapshot.data.data.shippingCost} ${snapshot.data.data.currency}", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),)),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(child: Text('Toplam', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 17),)),
                        Expanded(child: Text("${snapshot.data.data.paymentTotal} ${snapshot.data.data.currency}", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 17))),
                      ],
                    ),
                  ],
                ),
              )
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _productCard(AsyncSnapshot<CartModel> snapshot, int index) {
    return Card(
      child: Row(
        children: <Widget>[
          _productCardImage(snapshot, index),
          _productCardDetail(snapshot, index),
          _productCardDelete(snapshot, index)
        ],
      ),
    );
  }

  Widget _productCardDelete(AsyncSnapshot<CartModel> snapshot, int index) {
    return Container(
      width: MediaQuery.of(context).size.width / 6,
      alignment: Alignment.centerRight,
      child: IconButton(
        color: Colors.grey,
        icon: Icon(Icons.delete),
        onPressed: () => _productDelete(snapshot.data.data[index].productId),
      ),
    );
  }

  Widget _productCardDetail(AsyncSnapshot<CartModel> snapshot, int index) {
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${snapshot.data.data[index].quantity} ${snapshot.data.data[index].unit} x ", style: TextStyle(color: Colors.blueGrey)),
                    Text("${snapshot.data.data[index].price} ${snapshot.data.data[index].symbol}", style: TextStyle(color: Colors.blueGrey),),
                    SizedBox(width: 5,),
                    Text(snapshot.data.data[index].oldPrice != null ? "${snapshot.data.data[index].oldPrice} ${snapshot.data.data[index].symbol}" : "", style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough,),),
                  ],
                ),
                SizedBox(height: 7,),
                Text("${snapshot.data.data[index].totalPrice} ${snapshot.data.data[index].symbol}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepOrange),),
              ],
            ),
          ),
        );
  }

  Widget _productCardImage(AsyncSnapshot<CartModel> snapshot, int index) {
    return InkWell(
          onTap: () => pushNewScreen(context, screen: ProductPage(slug: snapshot.data.data[index].slug)),
          child: Container(
            width: MediaQuery.of(context).size.width/5,
            padding: EdgeInsets.only(top: 10, left: 5, bottom: 10),
            child: Image(image: NetworkImage(AppUrls.base + snapshot.data.data[index].image), fit: BoxFit.fitHeight,),
          ),
        );
  }

  _productDelete(String productId) async {
    var response = await http.delete("${AppUrls.cart}/${productId}",
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

      setState(() {
        _cartData = _getCart(_accessToken, _deviceId, _token);
        _cartTotalsData = _getCartTotals(_accessToken, _deviceId, _token);
      });

    } else {

      showDialog(
        context: context,
        child: AlertDialog(
          title: new Text("Bilgi"),
          content: new Text(AppStrings.generalError),
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

  Widget _checkoutButton() {
    return _cartData == null ? Text("") : Padding(
      padding: EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          onPressed: () => pushNewScreen(context, screen: AddressPage()),
          icon: Icon(CupertinoIcons.check_mark),
          label: Text("Alışverişi Tamamla"),
          color: Colors.deepOrange,
          textColor: Colors.white,),
      ),
    );
  }
}
//region Core
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/app_urls.dart';
import 'package:gps_tracker_mobile/core/constants/app_strings.dart';
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
import 'package:gps_tracker_mobile/models/products_category_model.dart';
import 'package:gps_tracker_mobile/models/category_model.dart';
//endregion

Future<CategoryModel> _getCategory(String accessToken, String deviceId, String token, String slug) async {
  var response = await http.get("${AppUrls.categories}/${slug}",
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok) {
    Map<String, dynamic> decodeJson = json.decode(response.body);
    CategoryModel category = CategoryModel.fromJson(decodeJson);

    return category;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<ProductsCategoryModel> _getProducts(String accessToken, String deviceId, String token, String slug) async {
  var response = await http.get("${AppUrls.categories}/${slug}/products",
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok) {
    Map<String, dynamic> decodeJson = json.decode(response.body);
    ProductsCategoryModel products = ProductsCategoryModel.fromJson(decodeJson);

    return products;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

class ProductsCategoryPage extends StatefulWidget {

  final String slug;

  ProductsCategoryPage({Key key, @required this.slug}) : super(key: key);

  @override
  _ProductsCategoryPageState createState() => _ProductsCategoryPageState();
}

class _ProductsCategoryPageState extends State<ProductsCategoryPage> {

  Future<CategoryModel> _categoryData;
  Future<ProductsCategoryModel> _productsData;

  SharedPreferences _sharedPreferences;

  String _accessToken, _deviceId, _token;

  @override
  void initState() {

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      _categoryData = _getCategory(_accessToken, _deviceId, _token, widget.slug);
      _productsData = _getProducts(_accessToken, _deviceId, _token, widget.slug);

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
        body: Column(
          children: <Widget>[
            _sortFilterBar(),
            Expanded(
              child:  _productsLists(),
            )
          ],
        ),
      ),
    );
  }

  Row _sortFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DropdownButton<String>(
          hint: Text("Sıralama Seçiniz"),
          icon: Icon(Icons.sort),
          items: <String>['Fiyat Artan', 'Fiyat Azalan', 'En Yeniler'].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        )
      ],
    );
  }

  Widget _appBarTitle() {
    return FutureBuilder(
        future: _categoryData,
        builder: (BuildContext context, AsyncSnapshot<CategoryModel> snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data.data.title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _productsLists() {
    return FutureBuilder(
        future: _productsData,
        builder: (BuildContext context, AsyncSnapshot<ProductsCategoryModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return GridView.count(
              primary: true,
              crossAxisCount: 2,
              childAspectRatio: 0.95,
              children: List.generate(snapshot.data.data.length, (index) {
                return _productCard(snapshot, index);
              }),
            );
          } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
            return Center(child: Text(AppStrings.productNotFoundInCategory),);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _productCard(AsyncSnapshot<ProductsCategoryModel> snapshot, int index) {
    return InkWell(
      onTap: (){
        setState(() {
            pushNewScreen(context, screen: ProductPage(slug: snapshot.data.data[index].slug));
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
                  Image(image: NetworkImage(AppUrls.base + snapshot.data.data[index].image), fit: BoxFit.fitHeight, height: 125,),
                  Positioned(
                    top: 0,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: (null == snapshot.data.data[index].discountRate ? null : Colors.redAccent)
                      ),
                      padding: EdgeInsets.all(4.0),
                      child: Text((null == snapshot.data.data[index].discountRate ? "" : "-%" +double.parse(snapshot.data.data[index].discountRate).toStringAsFixed(0)),
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
                  Text(snapshot.data.data[index].brand,
                      style: TextStyle(fontSize: 11, color: Colors.grey,),
                  ),
                  Row(
                    children: <Widget>[
                      Text((snapshot.data.data[index].score != null ? double.parse(snapshot.data.data[index].score).toStringAsFixed(1) : ""),
                        style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                      ),
                      IconTheme(
                        data: IconThemeData(color: Colors.amber, size: 48,),
                        child: StarDisplayWidget(value: (snapshot.data.data[index].score != null ? int.parse(snapshot.data.data[index].score) : 0), size: 15,),
                      )
                    ],
                  ),
                  Text(snapshot.data.data[index].title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.left, maxLines: 1, ),
                  Row(
                    children: <Widget>[
                      Text(double.parse(snapshot.data.data[index].discountPrice) == 0 ? "${snapshot.data.data[index].salePrice} ${snapshot.data.data[index].currency}" : "", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 12),),
                      Text(double.parse(snapshot.data.data[index].discountPrice) > 0 ? "${snapshot.data.data[index].salePrice} ${snapshot.data.data[index].currency}" : "", style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 11),),
                      Text(double.parse(snapshot.data.data[index].discountPrice) > 0 ? " ${snapshot.data.data[index].discountPrice} ${snapshot.data.data[index].currency}" : "", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12), ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
    ),
    );
  }
}

//region Core
import 'dart:io';
import 'package:flutter/material.dart';
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
import 'package:gps_tracker_mobile/pages/catalog/products_category.dart';
//endregion

//region Models
import 'package:gps_tracker_mobile/models/categories_model.dart';
//endregion

Future<CategoriesModel> _getCategories(String accessToken, String deviceId, String token, int categoryId) async {

  var url = (categoryId == null ? AppUrls.categories : "${AppUrls.categories}?category_id=${categoryId.toString()}");

  var response = await http.get(url,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    CategoriesModel categories = CategoriesModel.fromJson(decodeJson);

    return categories;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<CategoriesModel> _getParentCategories(String accessToken, String deviceId, String token, int categoryId) async {

  var url = (categoryId == null ? AppUrls.categories : "${AppUrls.categories}?category_id=${categoryId.toString()}");

  var response = await http.get(url,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    CategoriesModel parentCategories = CategoriesModel.fromJson(decodeJson);

    return parentCategories;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  Future<CategoriesModel> _categoriesData;
  Future<CategoriesModel> _parentCategoriesData;

  SharedPreferences _sharedPreferences;

  String _accessToken, _deviceId, _token;

  @override
  void initState() {

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      _categoriesData = _getCategories(_accessToken, _deviceId, _token, null);
      _parentCategoriesData = _getParentCategories(_accessToken, _deviceId, _token, null);

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
        title: Text("Kategoriler", style: TextStyle(fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,),
        ),
      ),
      body: Column(
        children: <Widget>[
          _parentCategory(context),
          _categories(),
        ],
      ),
    );
  }

  Expanded _categories() {
    return Expanded(
          child: FutureBuilder(future: _categoriesData, builder: (BuildContext context, AsyncSnapshot<CategoriesModel> snapshot){
            if(snapshot.hasData){
              return ListView.builder(itemCount: snapshot.data.data.length, itemBuilder: (BuildContext context, index){
                return ListTile(
                  title: Text(snapshot.data.data[index].title),
                  leading: CircleAvatar(child: Text(snapshot.data.data[index].title.toString()[0]),),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    setState(() {
                      if (int.parse(snapshot.data.data[index].subCategoryCount) == 0) {
                        pushNewScreen(context, screen: ProductsCategoryPage(slug: snapshot.data.data[index].slug));
                      } else {
                        _categoriesData = _getCategories(_accessToken, _deviceId, _token, int.parse(snapshot.data.data[index].id.toString()));
                        _parentCategoriesData = _getParentCategories(_accessToken, _deviceId, _token, null != snapshot.data.data[index].parentCategoryId ? int.parse(snapshot.data.data[index].parentCategoryId) : null);
                      }
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

  Container _parentCategory(BuildContext context) {
    return Container(
            height: MediaQuery.of(context).size.height/15,
            width: double.infinity,
            margin: EdgeInsets.only(left: 10, right: 10),
            child: FutureBuilder(future: _parentCategoriesData, builder: (BuildContext context, AsyncSnapshot<CategoriesModel> snapshot){
              if(snapshot.hasData){
                return ListView.builder(scrollDirection: Axis.horizontal, itemCount: snapshot.data.data.length, itemBuilder: (BuildContext context, index){
                  return InkWell(
                    onTap: () {
                      setState(() {
                          _categoriesData = _getCategories(_accessToken, _deviceId, _token, int.parse(snapshot.data.data[index].id.toString()));
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width/5,
                      margin: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 4, style: BorderStyle.solid, color: Colors.blueAccent))
                      ),
                      child: Text(
                          snapshot.data.data[index].title,
                          textAlign: TextAlign.center
                      ),
                    ),
                  );
                });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        );
  }
}
//region Core
import 'package:gps_tracker_mobile/models/empty_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/app_urls.dart';
import 'package:gps_tracker_mobile/core/constants/enums/status_code.dart';
import 'package:gps_tracker_mobile/core/functions/try_parse.dart';
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
import 'package:gps_tracker_mobile/core/constants/app_strings.dart';
import 'package:gps_tracker_mobile/core/widgets/counter.dart';
//endregion

//region Page
//endregion

//region Widgets
import 'package:gps_tracker_mobile/core/widgets/star_display.dart';
//endregion

//region Models
import 'package:gps_tracker_mobile/models/product_model.dart';
import 'package:gps_tracker_mobile/models/product_images_model.dart';
import 'package:gps_tracker_mobile/models/product_videos_model.dart';
import 'package:gps_tracker_mobile/models/product_comments_model.dart';
//endregion

Future<ProductModel> _getProduct(String accessToken, String deviceId, String token, String slug) async {
  var response = await http.get("${AppUrls.products}/${slug}",
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': StorageKey.token
      });

  if (response.statusCode == StatusCode.ok) {
    Map<String, dynamic> decodeJson = json.decode(response.body);
    ProductModel product = ProductModel.fromJson(decodeJson);

    return product;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<ProductImagesModel> _getImages(String accessToken, String deviceId, String token, String slug) async {
  var response = await http.get("${AppUrls.products}/${slug}/images",
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok) {
    Map<String, dynamic> decodeJson = json.decode(response.body);
    ProductImagesModel images = ProductImagesModel.fromJson(decodeJson);

    return images;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<ProductVideosModel> _getVideos(String accessToken, String deviceId, String token, String slug) async {
  var response = await http.get("${AppUrls.products}/${slug}/videos",
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok) {
    Map<String, dynamic> decodeJson = json.decode(response.body);
    ProductVideosModel videos = ProductVideosModel.fromJson(decodeJson);

    return videos;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

Future<ProductCommentsModel> _getComments(String accessToken, String deviceId, String token, String slug) async {
  var response = await http.get("${AppUrls.products}/${slug}/comments",
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${accessToken}",
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token
      });

  if (response.statusCode == StatusCode.ok) {
    Map<String, dynamic> decodeJson = json.decode(response.body);
    ProductCommentsModel comments = ProductCommentsModel.fromJson(decodeJson);

    return comments;
  } else {
    throw Exception("Bağlanamadık ${response.statusCode}");
  }
}

class ProductPage extends StatefulWidget {

  final String slug;

  ProductPage({Key key, @required this.slug}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  Future<ProductModel> _productData;
  Future<ProductImagesModel> _imagesData;
  Future<ProductCommentsModel> _commentsData;

  SharedPreferences _sharedPreferences;

  String _accessToken, _deviceId, _token;

  num _quantity;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      _productData = _getProduct(_accessToken, _deviceId, _token, this.widget.slug);
      _imagesData = _getImages(_accessToken, _deviceId, _token, this.widget.slug);
      _commentsData = _getComments(_accessToken, _deviceId, _token, this.widget.slug);

      _quantity = 1;

      setState(() {});
    });

    super.initState();
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
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.search, color: Colors.black),
//              onPressed: () => Navigator.of(context).pop(),
//            )
//          ],
        ),
        //bottomNavigationBar: _priceAndBasketBottomBar(),
        body:
        ListView(
          children: <Widget>[
            _productSlider(),
            _productDetail()
          ],
        ),
      ),
    );
  }

  BottomAppBar _priceAndBasketBottomBar() {
    return BottomAppBar(
        color: Colors.grey.shade300,
        child: FutureBuilder(
            future: _productData, builder: (BuildContext context, AsyncSnapshot<ProductModel> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: (null == snapshot.data.data.discountRate ? null : Colors.redAccent)
                    ),
                    padding: EdgeInsets.all(4.0),
                    child: Text((null == snapshot.data.data.discountRate ? "" : "-%" +double.parse(snapshot.data.data.discountRate).toStringAsFixed(0)),
                        style: TextStyle(backgroundColor: Colors.red, color: Colors.white)),
                  ),
                  Text(double.parse(snapshot.data.data.discountPrice) == 0 ? "${snapshot.data.data.salePrice} ${snapshot.data.data.currency}" : "", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 14),),
                  SizedBox(width: 10,),
                  Container(
                    height: MediaQuery.of(context).size.height/20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(double.parse(snapshot.data.data.discountPrice) > 0 ? "${snapshot.data.data.salePrice} ${snapshot.data.data.currency}" : "", style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 11),),
                        Text(double.parse(snapshot.data.data.discountPrice) > 0 ? " ${snapshot.data.data.discountPrice} ${snapshot.data.data.currency}" : "", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14), ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/20,
                    width: MediaQuery.of(context).size.width/2,
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      icon: Icon(CupertinoIcons.shopping_cart),
                      label: Text("Sepete At"),
                      color: Colors.deepOrangeAccent,
                      textColor: Colors.white,
                      onPressed: () async {

                        var response = await http.post("${AppUrls.cart}/${snapshot.data.data.id.toString()}",
                            body: <String, String>{
                              "quantity" : _quantity.toString()
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

                      },
                    ),
                  )
                ],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        }),
      );
  }

  FutureBuilder<ProductModel> _productDetail() {
    return FutureBuilder(future: _productData, builder: (BuildContext context, AsyncSnapshot<ProductModel> snapshot) {
      if (snapshot.hasData) {
        return Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Text(snapshot.data.data.title, style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5,),
              Text(snapshot.data.data.shortDescription, style: TextStyle(fontSize: 14, color: Colors.black54,),),
              SizedBox(height: 5,),
              Row(
                children: <Widget>[
                  Text((snapshot.data.data.score != null ? double.parse(snapshot.data.data.score).toStringAsFixed(1) : ""), style: TextStyle(fontSize: 12, color: Colors.blueGrey),),
                  IconTheme(
                    data: IconThemeData(color: Colors.amber, size: 48,),
                    child: StarDisplayWidget(value: (snapshot.data.data.score != null ? int.parse(snapshot.data.data.score) : 0)),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: (null == snapshot.data.data.discountRate ? null : Colors.redAccent)
                    ),
                    padding: EdgeInsets.all(4.0),
                    child: Text((null == snapshot.data.data.discountRate ? "" : "-%" +double.parse(snapshot.data.data.discountRate).toStringAsFixed(0)), style: TextStyle(backgroundColor: Colors.red, color: Colors.white)),
                  ),
                  Text(double.parse(snapshot.data.data.discountPrice) == 0 ? "${snapshot.data.data.salePrice} ${snapshot.data.data.currency}" : "", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 14),),
                  SizedBox(width: 10,),
                  Container(
                    height: MediaQuery.of(context).size.height/20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(double.parse(snapshot.data.data.discountPrice) > 0 ? "${snapshot.data.data.salePrice} ${snapshot.data.data.currency}" : "", style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 11),),
                        Text(double.parse(snapshot.data.data.discountPrice) > 0 ? " ${snapshot.data.data.discountPrice} ${snapshot.data.data.currency}" : "", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14), ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/20,
                    width: MediaQuery.of(context).size.width/2,
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      icon: Icon(CupertinoIcons.shopping_cart),
                      label: Text("Sepete At"),
                      color: Colors.deepOrangeAccent,
                      textColor: Colors.white,
                      onPressed: () => _addProductInCart(snapshot.data.data.id),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 10,),
              Container(
                  alignment: Alignment.center,
                  child: Counter(
                    initialValue: null != _quantity ? _quantity : 1,
                    minValue: num.parse(snapshot.data.data.minPurchaseQuantity),
                    maxValue: num.parse(snapshot.data.data.maxPurchaseQuantity),
                    step: 1,
                    decimalPlaces: 0,
                    color: Colors.blueGrey,
                    onChanged: (value) { // get the latest value from here
                      setState(() {
                        _quantity = value;
                      });
                    },
                  )
              ),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 10,),
              Row(children: <Widget>[
                Text("Satıcı: "),
                InkWell(
                  child: Text(snapshot.data.data.partnerName,
                    style: TextStyle(color: Colors.indigo),),
                  onTap: ((){

                  }),
                ),
              ],
              ),
              Row(
                children: <Widget>[
                  snapshot.data.data.isFreeShip == "1" ? new FlatButton.icon(onPressed: null,
                    icon: Icon(Icons.local_shipping),
                    label: Text("Kargo Bedava"),
                    color: Colors.red,
                  ) : SizedBox.shrink(),
                  snapshot.data.data.isSameDayShip == "1" ? FlatButton.icon(onPressed: null,
                    icon: Icon(Icons.shutter_speed),
                    label: Text("Aynı Gün Kargo"),
                    color: Colors.red,
                  ) : SizedBox.shrink()
                ],
              ),
              Divider(),
              SizedBox(height: 8,),
              Html(data: parse(snapshot.data.data.description).outerHtml),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 10,),
              _productComments(context),
              SizedBox(height: 10,),
              Divider()
            ],
          ),
        );
      } else {
        return Center(child: CircularProgressIndicator(),);
      }
    });
  }

  Widget _productComments(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width/2-10,
              child: Text("Yorumlar", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              width: MediaQuery.of(context).size.width/2-10,
              child: Text("Yorum Yaz", textAlign: TextAlign.right, style: TextStyle(color: Colors.blueAccent),),
            ),
          ],
        ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(future: _commentsData,
                builder: (BuildContext context, AsyncSnapshot<ProductCommentsModel> snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(itemCount: snapshot.data.data.length, shrinkWrap: true, itemBuilder: (BuildContext context, index){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IconTheme(
                            data: IconThemeData(
                              color: Colors.amber,
                              size: 48,
                            ),
                            child: StarDisplayWidget(value: (snapshot.data.data[index].score != null ? int.parse(snapshot.data.data[index].score) : 0), size: 13,),
                          ),
                          SizedBox(height: 10,),
                          Text(snapshot.data.data[index].comment, style: TextStyle(fontSize: 13),),
                          SizedBox(height: 10,),
                          Text("${snapshot.data.data[index].name} ${snapshot.data.data[index].surname}", style: TextStyle(fontSize: 13, color: Colors.blueGrey),),
                          SizedBox(height: 8,),
                          Text(TryParse().getLocaleDatetime(snapshot.data.data[index].createdAt), style: TextStyle(fontSize: 11, color: Colors.grey),),
                          Divider()
                        ],
                      );
                    });
                  } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text(AppStrings.productNotComment, style: TextStyle(color: Colors.grey, fontSize: 13),));
                  }
                }),
          )
      ],
      ),
    );
  }

  Widget _productSlider() {


    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        FutureBuilder(future: _imagesData,
            builder: (BuildContext context, AsyncSnapshot<ProductImagesModel> snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return CarouselSlider.builder(
                  itemCount: snapshot.data.data.length,
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.height / 2,
                      autoPlay: false,
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
                      child: Image.network(AppUrls.base + snapshot.data.data[index].path, fit: BoxFit.fitHeight, width: 1000,),
                    );
                  },
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height/2,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            }),
        Positioned(
          top: 0,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.redAccent
            ),
            padding: EdgeInsets.all(10.0),
            child: FutureBuilder(future: _productData, builder: (BuildContext context, AsyncSnapshot<ProductModel> snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.white,),
                  onPressed: () => _addFavorites(snapshot.data.data.id.toString()),
                );
              } else {
                return SizedBox();
              }
            })
          ),
        )
      ],
    );

    return FutureBuilder(future: _imagesData,
              builder: (BuildContext context, AsyncSnapshot<ProductImagesModel> snapshot) {
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  return CarouselSlider.builder(
                    itemCount: snapshot.data.data.length,
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 2,
                        autoPlay: false,
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
                        child: Image.network(
                          AppUrls.base + snapshot.data.data[index].path,
                          fit: BoxFit.fitHeight,
                          width: 1000,),
                      );
                    },
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height/2,
                      child: Center(child: CircularProgressIndicator()),
                  );
                }
              });
  }

  Widget _appBarTitle() {
    return FutureBuilder(
        future: _productData, builder: (BuildContext context, AsyncSnapshot<ProductModel> snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot != null ? snapshot.data.data.brand : "Ürün Detayı",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }

  _addProductInCart(int productId) async {
    var response = await http.post("${AppUrls.cart}/${productId.toString()}",
        body: <String, String>{
          "quantity" : _quantity.toString()
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

  _addFavorites(String productId) async {

    var response = await http.post("${AppUrls.favorites}",
        body: <String, String>{
          "product_id" : productId
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

      showDialog(
        context: context,
        child: AlertDialog(
          title: new Text("Bilgi"),
          content: new Text(AppStrings.productAddedToFavorites),
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
          title: new Text("Uyarı"),
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
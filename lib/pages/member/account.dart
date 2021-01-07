//region Core
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/functions/validations.dart';
import 'package:gps_tracker_mobile/core/constants/app_urls.dart';
import 'package:gps_tracker_mobile/core/constants/enums/status_code.dart';
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
//endregion

//region Page
import 'package:gps_tracker_mobile/pages/member/login.dart';
//endregion

//region Widgets
//endregion

//region Models
import 'package:gps_tracker_mobile/models/member_model.dart';
//endregion

class AccountPage extends StatefulWidget {

  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  String _formName, _formSurname, _formMail, _formPhone, _formPassword, _formPasswordConfirm;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textPassword = TextEditingController();

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

      _isLogin = _sharedPreferences.getBool(StorageKey.isLogin) != null ? _sharedPreferences.getBool(StorageKey.isLogin) : false;

      if (!_isLogin) {
        //pushNewScreen(context, screen: LoginPage());
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            /*leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),*/
            title: Text(
              "Hesabınız", style: TextStyle(fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
            ),
        ),
        body: ListView(
          children: ListTile.divideTiles(
              context: context,
              tiles: [
            ListTile(
              leading: Icon(Icons.local_shipping),
              title: Text("Siparişleriniz"),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Çıkış Yap'),
              onTap: (){
                SharedPreferences.getInstance().then((SharedPreferences sp) {
                  _sharedPreferences = sp;

                  debugPrint(_sharedPreferences.getBool(StorageKey.isLogin).toString());

                  _sharedPreferences.remove(StorageKey.memberId);
                  _sharedPreferences.remove(StorageKey.isLogin);

                  debugPrint(_sharedPreferences.getBool(StorageKey.isLogin).toString());

                  //Navigator.push(context, new MaterialPageRoute(builder: (context) => LoginPage()));
                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginPage()));

                  setState(() {});
                });
              },
            ),
          ]).toList(),
        ),
      ),
    );
  }

  Container registerForm(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Adınız",
                  labelText: "Adınız",
                  prefixIcon: Icon(Icons.assignment_ind),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0),
                    ),
                  ),
                ),
                validator: (String value) {
                  return value.length < 6 ? "Adınızı giriniz." : null;
                },
                onSaved: (value) => _formName = value,
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Soyadınız",
                  labelText: "Soyadınız",
                  prefixIcon: Icon(Icons.assignment_ind),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0),
                    ),
                  ),
                ),
                validator: (String value) {
                  return value.length < 6 ? "Soyadınızı giriniz." : null;
                },
                onSaved: (value) => _formSurname = value,
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "E-posta Adresiniz",
                  labelText: "E-posta Adresiniz",
                  prefixIcon: Icon(Icons.supervised_user_circle),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0),
                    ),
                  ),
                ),
                validator: (String value) {
                  return Validations().isMail(value) == false ? "E-posta adresinizi giriniz." : null;
                },
                onSaved: (value) => _formMail = value,
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Cep Telefonu",
                  labelText: "Cep Telefonu",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0),
                    ),
                  ),
                ),
                validator: (String value) {
                  return value.length < 6 ? "Cep telefonu numaranızı giriniz." : null;
                },
                onSaved: (value) => _formPhone = value,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _textPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: "Şifreniz",
                  labelText: "Şifreniz",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0),
                    ),
                  ),
                ),
                validator: (String value) {
                  return value.length < 6 ? "Şifrenizi giriniz." : null;
                },
                onSaved: (value) => _formPassword = value,
              ),
              SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: "Şifre Tekrar",
                  labelText: "Şifre Tekrar",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0),
                    ),
                  ),
                ),
                validator: (String value) {
                  return value.length < 6 && _formPassword != value  ? "Şifrenizi kontrol ediniz." : null;
                }
              ),
              SizedBox(height: 10,),
              SizedBox(height: 50,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: _register,
                  child: Text('HESAP OLUŞTUR', style: TextStyle(color: Colors.green.shade100),),
                ),
              ),
              SizedBox(height: 50,),
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Text("Hesabınız var mı? Hemen giriş yapın.", style: TextStyle(color: Colors.grey.shade700),),
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _register() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var response = await http.post(AppUrls.login,
        body: jsonEncode(<String, String>{
          'name': _formName,
          'surname': _formSurname,
          'mail': _formMail,
          'phone': _formPhone,
          'password': _formPassword,
          'passwordConfirm': _formPasswordConfirm
        }),
        headers: <String, String>{
          //HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer ${_accessToken}",
          'X-DEVICE-ID': _deviceId,
          'X-TOKEN': _token
        },
      );

      if (response.statusCode == StatusCode.ok) {
        Map<String, dynamic> decodeJson = json.decode(response.body);
        MemberModel videos = MemberModel.fromJson(decodeJson);

        print(videos.error.message);
        //Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();
        AlertDialog(
          title: Text("Giriş yapıldı"),
          content: Text("giriş yapıldı ama nasıl yapıldı gel bana sor"),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      } else {
        AlertDialog(
          title: Text("Giriş yapılmadı"),
          content: Text("giriş yapılmadı ama neden yapılmadı"),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    }
  }
}
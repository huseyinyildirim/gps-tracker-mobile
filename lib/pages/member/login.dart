//region Core
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/app_urls.dart';
import 'package:gps_tracker_mobile/core/constants/enums/status_code.dart';
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
import 'package:gps_tracker_mobile/core/functions/validations.dart';
//endregion

//region Page
import 'package:gps_tracker_mobile/pages/member/register.dart';
import 'package:gps_tracker_mobile/pages/member/account.dart';
//endregion

//region Widgets
//endregion

//region Models
import 'package:gps_tracker_mobile/models/member_model.dart';
import 'package:gps_tracker_mobile/models/empty_model.dart';
//endregion

class LoginPage extends StatefulWidget {

  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _formMail, _formPassword;

  final _formKey = GlobalKey<FormState>();

  SharedPreferences _sharedPreferences;

  String _deviceId, _token, _accessToken;
  bool _isLogin;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

      _isLogin = _sharedPreferences.getBool(StorageKey.isLogin) != null ? _sharedPreferences.getBool(StorageKey.isLogin) : false;

      if (_isLogin) {
        //pushNewScreen(context, screen: AccountPage());
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new AccountPage()));
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
          title: Text("Giriş Yap", style: TextStyle(fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
          )
      ),
      body: loginForm(context),
    );
  }

  Container loginForm(BuildContext context) {
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
                hintText: "E-posta Adresiniz",
                labelText: "E-posta Adresiniz",
                prefixIcon: Icon(Icons.supervised_user_circle),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0),
                    ),
                ),
              ),
              validator: (String value) {
                return Validations().isMail(value) ? null : "E-posta adresinizi kontrol ediniz." ;
              },
              onSaved: (value) => _formMail = value,
            ),
            SizedBox(height: 10,),
            TextFormField(
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
            SizedBox(height: 50,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              color: Colors.green,
              onPressed: _login,
              child: Text('GİRİŞ YAP', style: TextStyle(color: Colors.green.shade100),),
            ),
            ),
            SizedBox(height: 50,),
            InkWell(
              onTap: (){
                //pushNewScreen(context, screen: RegisterPage());
                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new RegisterPage()));
              },
              child: Text("Hesabınız yok mu? Hemen ücretsiz hesap oluşturun.", style: TextStyle(color: Colors.grey.shade700),),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var response = await http.post(AppUrls.login,
          body: <String, String>{
            "mail" : _formMail,
            "password" : _formPassword
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
        MemberModel member = MemberModel.fromJson(decodeJson);

        SharedPreferences.getInstance().then((SharedPreferences sp) {
          _sharedPreferences = sp;

          _sharedPreferences.setInt(StorageKey.memberId, member.data.id);
          _sharedPreferences.setBool(StorageKey.isLogin, true);

          Future.delayed(const Duration(seconds: 1), () async {
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new AccountPage()));
          });

          setState(() {});
        });

      } else {

        Map<String, dynamic> decodeJson = json.decode(response.body);
        EmptyModel empty = EmptyModel.fromJson(decodeJson);

        showDialog(
            context: context,
            child: AlertDialog(
              title: new Text("Bilgi"),
              content: new Text(empty.error.message),
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
}

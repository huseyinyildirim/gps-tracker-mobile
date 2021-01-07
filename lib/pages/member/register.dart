//region Core
import 'dart:convert';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';
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
import 'package:gps_tracker_mobile/core/constants/app_strings.dart';
//endregion

//region Page
import 'package:gps_tracker_mobile/pages/member/login.dart';
//endregion

//region Widgets
//endregion

//region Models
import 'package:gps_tracker_mobile/models/member_model.dart';
import 'package:gps_tracker_mobile/models/empty_model.dart';
//endregion

class RegisterPage extends StatefulWidget {

  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _formName, _formSurname, _formMail, _formMobile, _formPassword, _formPasswordConfirm;
  bool _kvkk = false;
  bool _isNewsletter = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textPassword = TextEditingController();

  SharedPreferences _sharedPreferences;

  String _accessToken, _deviceId, _token;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId);
      _token = _sharedPreferences.getString(StorageKey.token);
      _accessToken = _sharedPreferences.getString(StorageKey.accessToken);

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
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Hesap Oluştur", style: TextStyle(fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,),
            )
        ),
        body: registerForm(context),
      ),
    );
  }

  Widget registerForm(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20),
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
                onSaved: (value) => _formMobile = value,
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
              CheckboxListTile(
                title: Text("Üyelik koşullarını ve kişisel verilerimin korunmasını kabul ediyorum.", style: TextStyle(fontSize: 13),),
                value: _kvkk,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool value) {
                    setState(() {
                      _kvkk = value;
                    });
                  },
              ),
              CheckboxListTile(
                  title: Text("Kampanya ve yenilikler hakkında bilgi almak istiyorum.", style: TextStyle(fontSize: 13),),
                  value: _isNewsletter,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool value) {
                    setState(() {
                      _isNewsletter = value;
                    });
                  }
              ),
              SizedBox(height: 10,),
              SizedBox(height: 50,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: _register,
                  child: Text('HESAP OLUŞTUR', style: TextStyle(color: Colors.white),),
                ),
              ),
              SizedBox(height: 40,),
              InkWell(
                onTap: (){
                  pushNewScreen(context, screen: LoginPage());
                },
                child: Text("Hesabınız var mı? Hemen giriş yapın.", style: TextStyle(color: Colors.grey.shade700),),
              ),
              SizedBox(height: 40,),
            ],
          ),
        ),
      );
  }

  Future<void> _register() async {

    if (_kvkk == false) {

      showDialog(
        context: context,
        child: AlertDialog(
          title: new Text("Uyarı"),
          content: new Html(data: "Sözleşmeleri kabul etmeniz gerekmektedir."),
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

      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        var response = await http.post(AppUrls.register,
          body: <String, String>{
            "name" : _formName,
            "surname" : _formSurname,
            "mail" : _formMail,
            "mobile" : _formMobile,
            "password" : _formPassword,
            //"password_confirm" : _formPasswordConfirm,
            "is_newsletter" : _isNewsletter ? "1" : "0"
          },
          headers: <String, String>{
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: "Bearer ${_accessToken}",
            'X-DEVICE-ID': _deviceId,
            'X-TOKEN': _token
          },
        );

        if (response.statusCode == StatusCode.ok) {

          Map<String, dynamic> decodeJson = json.decode(response.body);
          MemberModel memberModel = MemberModel.fromJson(decodeJson);

          // TODO: Bunları bir fonksiyon yap
          showDialog(
            context: context,
            child: AlertDialog(
              title: new Text("Başarılı"),
              content: new Html(data: memberModel.message != null ? memberModel.message : AppStrings.successRegister),
              actions: <Widget>[
                FlatButton(
                  child: Text('Kapat'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginPage()));
                  },
                )
              ],
            ),
          );

        } else {

          Map<String, dynamic> decodeJson = json.decode(response.body);
          EmptyModel emptyModel = EmptyModel.fromJson(decodeJson);

          showDialog(
            context: context,
            child: AlertDialog(
              title: new Text("Uyarı"),
              content: new Html(data: emptyModel.error.message),
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
}
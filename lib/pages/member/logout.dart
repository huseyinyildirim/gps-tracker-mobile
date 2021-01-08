//region Core
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
//endregion

//region Page

//endregion

//region Widgets
//endregion

//region Models
import 'login.dart';
//endregion

class LogoutPage extends StatefulWidget {

  const LogoutPage({Key key}) : super(key: key);

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {

  String _formMail, _formPassword;

  final _formKey = GlobalKey<FormState>();

  SharedPreferences _sharedPreferences;

  String _deviceId, _token, _accessToken;
  bool _isLogin;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      debugPrint(_sharedPreferences.getBool(StorageKey.isLogin).toString());

      _sharedPreferences.remove(StorageKey.customerId);
      _sharedPreferences.remove(StorageKey.isLogin);

      debugPrint(_sharedPreferences.getBool(StorageKey.isLogin).toString());

      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginPage()));

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
          title: Text("Çıkış", style: TextStyle(fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
          )
      ),
      body: null,
    );
  }
}

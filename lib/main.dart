//region Core
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
//endregion

//region Custom Core
import 'package:gps_tracker_mobile/core/constants/app_urls.dart';
import 'package:gps_tracker_mobile/core/constants/enums/status_code.dart';
import 'package:gps_tracker_mobile/core/constants/enums/storage_key.dart';
import 'package:gps_tracker_mobile/core/constants/app_strings.dart';
//endregion

//region Page
import 'package:gps_tracker_mobile/pages/welcome.dart';
//endregion

//region Widgets
//endregion

//region Models
import 'package:gps_tracker_mobile/models/handshake_model.dart';
//endregion

final SentryClient _sentry = new SentryClient(dsn: "https://a182c5eed4044779b8138a39b1624534@o284904.ingest.sentry.io/5272950");

Future<HandshakeModel> _getHandshake(String deviceId, String token) async {
  var response = await http.get(AppUrls.handshake,
      headers: {
        //HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        'X-DEVICE-ID': deviceId,
        'X-TOKEN': token,
      });

  if (response.statusCode == StatusCode.ok){

    Map<String, dynamic> decodeJson = json.decode(response.body);
    HandshakeModel handshake = HandshakeModel.fromJson(decodeJson);

    return handshake;
  } else {

    return null;
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;
  //assert(inDebugMode = true);
  return inDebugMode;
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');

  if (isInDebugMode) {
    print(stackTrace);
    print("Geliştirici modundadır. Sentry.io\'ya rapor gönderilmiyor.");
    return;
  }

  print("Sentry.io'ya bildiriliyor ...");

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Başarılı! Hata Numarası: ${response.eventId}');
  } else {
    print("Sentry.io'ya rapor edilemedi: ${response.error}");
  }
}

/*
 * Flutter'da oluşan hatalarıda yakalar
 */
Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZonedGuarded<Future<Null>>(() async {
    runApp(new MyApp());
  }, (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BulutReyonApp()
    );
  }
}

class BulutReyonApp extends StatefulWidget {

  const BulutReyonApp({Key key}) : super(key: key);

  @override
  _BulutReyonAppState createState() => _BulutReyonAppState();
}

class _BulutReyonAppState extends State<BulutReyonApp> {

  SharedPreferences _sharedPreferences;

  String _deviceId, _token;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;

      _deviceId = _sharedPreferences.getString(StorageKey.deviceId) != null ? _sharedPreferences.getString(StorageKey.deviceId) : Uuid().v1();
      _token = _sharedPreferences.getString(StorageKey.token) != null ? _sharedPreferences.getString(StorageKey.token) : Uuid().v4();

      _getHandshake(_deviceId, _token).then((value) {
        if (value.statusCode == StatusCode.ok) {

          _sharedPreferences.setString(StorageKey.deviceId, _deviceId);
          _sharedPreferences.setString(StorageKey.token, _token);
          _sharedPreferences.setString(StorageKey.accessToken, value.data);

          Future.delayed(const Duration(seconds: 4), () async {
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new WelcomePage()));
          });
        } else {
          showDialog(
            context: context,
            builder: (_) =>
                AlertDialog(
                  title: Text(AppStrings.splashNotConnection),
                  content: Text(AppStrings.splashNotConnectionDetail),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Kapat!'),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    )
                  ],
                ),
          );
        }
      });

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: splash(),
    );
  }

  Stack splash() {
    return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blueAccent, Colors.redAccent]
            )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.blueAccent,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text(
                        "Elit Reyon",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70),),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Aradığınız Her Şey Bu Reyonlarda",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18.0,
                          color: Colors.white.withOpacity(0.8)),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      );
  }
}
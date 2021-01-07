import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {

  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;

  static Future getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  StorageUtil._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // get string
  static Future<String> getString(String key, {String defValue = ''}) async {
    //if (_preferences == null) return defValue;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? defValue;
  }

  // put string
  static Future<bool> setString(String key, String value) async {
    //if (_preferences == null) return null;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

}
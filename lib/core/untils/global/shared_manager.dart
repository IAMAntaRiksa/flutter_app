import 'package:shared_preferences/shared_preferences.dart';

class SharedManager<T> {
  late SharedPreferences _prefs;
  Type type<T>() => T;

  Future<T?> read(String key) async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey(key)) {
      switch (type<T>()) {
        case String:
          return _prefs.getString(key) as T;
        case int:
          return _prefs.getInt(key) as T;
        case double:
          return _prefs.getDouble(key) as T;
        case List<String>:
          return _prefs.getStringList(key) as T;
        default:
          return null;
      }
    }
    return null;
  }

  Future<void> store(String key, dynamic value) async {
    _prefs = await SharedPreferences.getInstance();
    switch (type<T>()) {
      case String:
        _prefs.setString(key, value);
        break;
      case int:
        _prefs.setInt(key, value);
        break;
      case double:
        _prefs.setDouble(key, value);
        break;
      case bool:
        _prefs.setBool(key, value);
        break;
      case List<String>:
        _prefs.setStringList(key, value);
        break;
      default:
    }
  }

  Future<void> clear() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
  }
}

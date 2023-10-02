import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_storage_service_base.dart';

class SharedPreferencesKeyValueStorageServices extends KeyValueStorageServiceBase {
  SharedPreferencesKeyValueStorageServices() {
        SharedPreferences.setPrefix('flutter-teslo-app');
  }

  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await _getSharedPreferencesInstance();

    switch (T) {
      case bool:
        return prefs.getBool(key) as T?;
      case int:
        return prefs.getInt(key) as T?;
      case double:
        return prefs.getDouble(key) as T?;
      case String:
        return prefs.getString(key) as T?;
      case List<String>:
        return prefs.getStringList(key) as T?;
      default:
        throw UnimplementedError('Tipo de dato no soportado: ${T.runtimeType}');
    }
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    final prefs = await _getSharedPreferencesInstance();

    switch (T) {
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case int:
        prefs.setInt(key, value as int);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      case List<String>:
        prefs.setStringList(key, value as List<String>);
        break;
      default:
        throw UnimplementedError('Tipo de dato no soportado: ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async
    => (await _getSharedPreferencesInstance()).remove(key);
}
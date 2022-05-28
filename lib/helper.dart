import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class helper {
  static Future getData(key) async{
    final prefs = await SharedPreferences.getInstance();
    final String? value = await prefs.getString(key);
    return value;
  }

  static Future setData(key, data) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }

}
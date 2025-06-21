import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class PhoneInfo{
  Future keyDepolama(String unique_key) async {
    print("key depolama ${unique_key}");
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("unique_key", unique_key);
  }
  Future<String> keyOkuma() async {
    try{
       final prefs = await SharedPreferences.getInstance();
       print("key okuma ${prefs.getString("unique_key")}");
       String key =prefs.getString("unique_key") ?? ""; 
      return key;
    }
     catch (e){
      print("okuma hatası ${e}");
      return "";
     }
    
  }
  Future sunucuda() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("sunucu", true);
  }
  Future<Object> sunucudaMi() async {
    try{
       final prefs = await SharedPreferences.getInstance();
       bool key =prefs.getBool("sunucu") ?? false; 
      return key;
    }
     catch (e){
      print("okuma hatası ${e}");
      return false;
     }
    
  }
}   

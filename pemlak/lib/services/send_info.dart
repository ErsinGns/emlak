import 'dart:convert';

import 'package:http/http.dart' as http;

class SendInfo {
  String main_url = "http://192.168.1.111:5000/api/milli_emlak";
  Future<int?> fetchDelCity(String name, String unique_key) async {
    String url = main_url + "/del-city";
    try {
      var res = await http.post(
        Uri.parse(url),
        body: {"name": name, "unique_key": unique_key},

      );

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        var success = body["success"];
        if(success)
          return 1;
        else
          return 0;
      } else {
        print("Request failed with status: ${res.statusCode}");
      }
    } catch (e) {
      print("unable to access the server: ${e}");
    }
    return 0;
    
  }

  
  Future<int?> fetchAddNewCity(int plaka, String unique_key) async {
    String url = main_url + "/add-new-city";
    print(url);
    try {
      var res = await http.post(
        Uri.parse("http://192.168.1.111:5000/api/milli_emlak/add-new-city"),
        body: {"plaka": plaka.toString(), "unique_key" : unique_key},
      );

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        var success = body["success"];
        if(success)
          return 1;
        else
          return 0;
      } else {
        print("Request failed with status: ${res.statusCode}");
        
      }
    } catch (e) {
      print("unable to access the server: ${e}");
      
    }
    return 0;
  }


  Future<String> fetchNewUser() async{
    String url = main_url + "/add-new-user";
    try {
      

      var res = await http.get(
        Uri.parse(url),

      );
      if(res.statusCode == 200){
        var body = jsonDecode(res.body);
        var success = body["success"];
        if(success){
          String unique_key = body["data"];
          print("fecth new user ${unique_key}");
          return unique_key;
        }
        else{
          print("eşsiz anahtar gelmedi");
          return "";
        }
      }
    } catch (e) {
      print("unable to access the server: ${e}");
      
    }
    return "";
  }


  Future<String> fetchMesajKey(String message_key, String unique_key) async{
    String url = main_url + "/mesaj-key";
    try {
      

      var res = await http.post(
        Uri.parse(url),
        body: {"message_key": message_key, "unique_key" : unique_key}

      );
      if(res.statusCode == 200){
        var body = jsonDecode(res.body);
        var success = body["success"];
        if(success){
          String unique_key = body["data"];
          print("fecth new user ${unique_key}");
          return unique_key;
        }
        else{
          print("eşsiz anahtar gelmedi");
          return "";
        }
      }
    } catch (e) {
      print("unable to access the server: ${e}");
      
    }
    return "";
  }
  

}
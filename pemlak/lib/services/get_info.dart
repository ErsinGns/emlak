import 'dart:convert';
import 'package:pemlak/models/city_info.dart';
import 'package:http/http.dart' as http;

class GetInfo {
  String main_url = "http://192.168.1.111:5000/api/milli_emlak";

  Future<List<String>?> fetchCityList(String unique_key) async {
    List<String> cityListName = [];
    String url = main_url + "/send-user-city-list";

    try {
      var res =
          await http.post(Uri.parse(url), body: {"unique_key": unique_key});
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        var success = body["success"];
        if (success) {
          var datas = body["data"];
          datas.forEach((key, value) {
            cityListName.add(value);
          });

          return cityListName;
        } else {
          print("sorver başarısız dönüş yaptı.");
        }
      } else {
        print("sorever 200 den başka dönuş yaptı");
      }
    } catch (e) {
      print("servera erişirken bir sorun oluştu  ${e}");
    }
    return null;
  }

  Future<List<CityInfo>?> fetchCitiesInfo(String cityName) async {
    String url = main_url + "/sehir-emlak-bilgi";
    try {
      var res = await http.post(
        Uri.parse(url),
        body: {"il": cityName},
      );

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);

        List datas = body["data"];
        var success = body["success"];
        if (success) {
          int count = body["count"];
          List<CityInfo> cityInfoList = [];
          for (int i = 0; i < count; i++) {
            cityInfoList.add(CityInfo.fromJson(datas[i]));
          }

          return cityInfoList;
        } else {
          print("sorver başarısız dönüş yaptı.");
        }
      } else {
        print("Request failed with status: ${res.statusCode}");
        return null;
      }
    } catch (e) {
      print("unable to access the server: ${e}");
      return null;
    }
  }
}

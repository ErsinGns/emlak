import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pemlak/items/colors.dart';
import 'package:pemlak/mesaj/serbice.dart';
import 'package:pemlak/models/city_info.dart';
import 'package:pemlak/pages/city_list_page.dart';
import 'package:pemlak/services/get_info.dart';
import 'package:pemlak/services/phone_info.dart';
import 'package:pemlak/services/send_info.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, List<CityInfo>>> citysInfos = [];
  List<String> cityName = [];
  final _controller = TextEditingController();
  late String unique_key;
   String message_key = "kjak";

  GetInfo _getInfo = GetInfo();
  SendInfo _sendInfo = SendInfo();
  PhoneInfo _phoneInfo = PhoneInfo();

  

  Future<void> list_city_name_foo() async {
    final cityList = await _getInfo.fetchCityList(unique_key) ?? [];
    setState(() {
      cityName = cityList;
      citysInfos = cityName.map((name) => {name: <CityInfo>[]}).toList();
    });
  }

  Future<void> list_city_info_foo() async {
    final cityList = await _getInfo.fetchCityList(unique_key) ?? [];
    setState(() {
      cityName = cityList;
      citysInfos = cityName.map((name) => {name: <CityInfo>[]}).toList();
    });

    for (int i = 0; i < cityName.length; i++) {
      String name = cityName[i];
      try {
        final value = await _getInfo.fetchCitiesInfo(name);
        if (value != null) {
          setState(() {
            citysInfos[i][name] =
                value.cast<CityInfo>();
          });
        } else {
          print("Failed to fetch data for $name");
        }
      } catch (error) {
        print("An error occurred while fetching $name: $error");
      }
    }
  }

  Future<String> keyOku() async {
  unique_key = await _phoneInfo.keyOkuma();
  
  if (unique_key == "") {
 
  
    unique_key = await _sendInfo.fetchNewUser();
    print("key oku if ${unique_key}");
    
    await keyKaydet(unique_key);
    return unique_key;
  } else {
    print("key oku else ${unique_key}");
    return unique_key;
  }
}

  
  Future<void> keyKaydet(unique_key) async{
    _phoneInfo.keyDepolama(unique_key);
    print(unique_key);

  }

  @override
void initState() {
  super.initState();
  initData();
  setState(() {
    
  });
}

Future<void> initData() async {
  await keyOku();
  await list_city_name_foo();
  await list_city_info_foo();
}


  void list_city_name() {
    list_city_name_foo();
    list_city_info_foo();
    setState(() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.65,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            child: ListView.builder(
              itemCount: cityName.length,
              itemBuilder: (context, index) {
                return CityListPage(
                  name: cityName[index],
                  onDelete: (deletedCityName) {
                    setState(() {
                      cityName.remove(deletedCityName);
                      citysInfos.removeWhere(
                          (cityInfo) => cityInfo.keys.first == deletedCityName);
                    });
                  },
                );
              },
            ),
          ),
        ),
      );
    });
  }

  void add_new_city() {
    int id = int.tryParse(_controller.text) ?? 0;
    if (id != 0 && id > 0 && id < 82) {
      _controller.clear();

      _sendInfo.fetchAddNewCity(id, unique_key).then((value) {
        if (value == 1) {
          list_city_name_foo();
          list_city_info_foo();
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                 "Başarıyla eklendi",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          });
        } else {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                 "Zaten bu il ekli",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 1),
              ),
            );
          });
          print("bir hata oluştu");
        }
      }).catchError((error) {
        print("An error occurred while fetching: $error");
      });
    } else {
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Geçersiz şehir plakası",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double container_height = size.height * .34;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 16, 155),
      appBar: AppBar(
        title: const Text("Milli Emlak"),
        centerTitle: true,
        backgroundColor: Primary,
        titleTextStyle:
            TextStyle(color: Accent, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: BodyMethod(container_height),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 40),
        child: Row(
          children: [
            FloatingActionButton(
              onPressed: list_city_name,
              child: Icon(Icons.location_city),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: "İl giriniz.",
                      filled: true,
                      fillColor: Neutral,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Neutral.withOpacity(0.9),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Neutral.withOpacity(0.7),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: add_new_city,
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }

  ListView BodyMethod(double container_height) {
    return ListView.builder(
      itemCount: citysInfos.length,
      itemBuilder: (context, index) {
        String cityName = citysInfos[index].keys.first;
        List<CityInfo> cityData = citysInfos[index][cityName]!;
        return SizedBox(
          height: container_height,
          child: Stack(
            children: [
              city_real_estate(cityData),
              Positioned(
                top: 0,
                left: 10,
                child: Container(
                  padding: EdgeInsets.all(11),
                  child: Text(
                    cityName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  ListView city_real_estate(List<CityInfo> cityData) {
    return ListView.builder(
      itemCount: cityData.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            int id = cityData[index].id ?? 0;
            Uri url =
                Uri.parse("https://$id");
            try {
              await launchUrl(url);
            } catch (e) {
              print("url not open: $e");
            }
          },
          child: Container(
            width: 265,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Secondary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Secondary.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İlçe: ${cityData[index].ilce ?? 'Bilgi Yok'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: TextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Mahalle: ${cityData[index].mahalle ?? 'Bilgi Yok'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: TextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Ada: ${cityData[index].ada ?? 'Bilgi Yok'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: TextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Parsel: ${cityData[index].parsel ?? 'Bilgi Yok'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: TextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Yüz Ölçümü: ${cityData[index].yuzOlcumu ?? 'Bilgi Yok'} m²',
                    style: TextStyle(
                      fontSize: 14,
                      color: TextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'İhale Tarihi: ${cityData[index].ihaleTarihi ?? 'Bilgi Yok'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: TextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Geçici Teminat Bedeli: ${cityData[index].geciciTeminatBedelei ?? 'Bilgi Yok'} ₺',
                    style: TextStyle(
                      fontSize: 14,
                      color: TextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Toplam Tahmini Bedel: ${cityData[index].toplamTahminiBedel ?? 'Bilgi Yok'} ₺',
                    style: TextStyle(
                      fontSize: 14,
                      color: TextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

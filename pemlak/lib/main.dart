import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:pemlak/mesaj/serbice.dart';
import 'package:pemlak/pages/home_page.dart';
import 'package:pemlak/services/phone_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _service = FirebaseNotificationService();
  PhoneInfo _phoneInfo = PhoneInfo();

@override
void initState() {
  super.initState();
  _initializeData();
}

Future<void> _initializeData() async {
  Object key = await _phoneInfo.sunucudaMi();
  if(key == false){
    String unique_key = await _phoneInfo.keyOkuma();
  _service.connectNotification(unique_key);
  await _phoneInfo.sunucuda();
  }
  else{
    print("zaten sunucuda");
  }
  
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Grock.navigationKey,
      scaffoldMessengerKey: Grock.scaffoldMessengerKey,
      title: 'Milli Emlak',
      
      home: HomePage(),
    );
  }
}

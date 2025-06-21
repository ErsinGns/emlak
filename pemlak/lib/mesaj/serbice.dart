import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:grock/grock.dart';
import 'package:pemlak/services/send_info.dart';

class FirebaseNotificationService {
  late final FirebaseMessaging messaging;
  SendInfo _sendInfo = SendInfo();
  String? token;

  Future<void> settingNotification() async {
    await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  Future<void> connectNotification(String unique_key) async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
    await settingNotification();
    
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      Grock.snackBar(
        title: "${event.notification?.title}",
        description: "${event.notification?.body}",
        /* leading: event.notification?.android?.imageUrl == null
          ? null
          : Image.network(
              "${event.notification?.android?.imageUrl}",
            ), */
        opacity: 0.5,
        position: SnackbarPosition.top,
      );
      print("Gelen bildirim: ${event.notification?.title}");
    });

    token = await messaging.getToken();
    log("Token: $token", name: "FOM Token");
    _sendInfo.fetchMesajKey(token!, unique_key);
  }

  Future<String?> getToken() async{
    await token;
    print("token === ${token}");
    return token;
  }
}

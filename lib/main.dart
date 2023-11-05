import 'dart:async';

import 'package:campus_link_teachers/push_notification/helper_notification.dart';
// import 'dart:ui_web' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'Connection.dart';
import 'firebase_options.dart';




@pragma('vm:entry-point')
callbackDispatcherfordelevery() async {

  try{
    print(".......Starting workmanager executeTask   2.....");
    Workmanager().executeTask((taskName, inputData) async {
      try{
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        print(".............doc ${inputData?["channel"]}");
        print(".............stamp ${inputData?["stamp"]}");
        await FirebaseFirestore.instance.collection("Messages").doc(inputData?["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
            {
              "${inputData?["Email"]}_${inputData?["Stamp"]}_Delevered" : FieldValue.arrayUnion([
                {
                  "Email" : FirebaseAuth.instance.currentUser?.email,
                  "Stamp" : DateTime.now()
                }
              ])
            }
        );
      }
      catch (e){
        print("fucking error............................. $e ");
      }
      return Future.value(true);
    });

  }catch (e){
    print("..........error.........\n.........$e........");
  }
}


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message");
  }

  print(".............from background handler.............");

  //NotificationServices.display(message);

  print(message.data["msg"]);
  if(message.data["msg"]=="true"){
    try{
      Workmanager().initialize(
        callbackDispatcherfordelevery,
      );
      print(".......workmanager");
      await Workmanager().registerOneOffTask("Develered", "Delevery",inputData: {
        "channel" :message.data["channel"],
        "Stamp" : message.data["stamp"],
        "Email" : message.data["Email"],
      });
    }catch(e){
      print("........Error from background handler.........");
    }
  }
}
@pragma('vm:entry-point')
Future<void> firebaseMessagingonmessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a onmessage message");
  }

  print(".............From onmessage.............");
  if(message.data["msg"]=="true"){
    print(message.data["channel"]);
    await FirebaseFirestore.instance.collection("Messages").doc(message.data["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
        {
          "${message.data["Email"]}_${message.data["stamp"]}_Delevered" : FieldValue.arrayUnion([
            {
              "Email" : FirebaseAuth.instance.currentUser?.email,
              "Stamp" : DateTime.now()
            }
          ])
        }
    );
  }
  NotificationServices.display(message,"404");

}
@pragma('vm:entry-point')
Future<void> firebaseMessagingonmessageOpenedAppHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a onmessage message");
  }

  print(".............From onmessage Opened App.............");
  if(message.data["msg"]=="true"){
    try{
      await FirebaseFirestore.instance
          .collection("Messages")
          .doc(message.data["channel"])
          .collection("Messages_Detail")
          .doc("Messages_Detail")
          .update({
        "${message.data["Email"]}_${message.data["stamp"]}_Delevered":
            FieldValue.arrayUnion([
          {
            "Email": FirebaseAuth.instance.currentUser?.email,
            "Stamp": DateTime.now()
          }
        ])
      });
    } catch(e){
      print(".........$e");
  }
  }
  NotificationServices.display(message,"404");

}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  // ui.platformViewRegistry
  //     .registerViewFactory('example', (_) => DivElement()..innerText = 'Hello, HTML!');
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum LocationStatus { UNKNOWN, INITIALIZED, RUNNING, STOPPED }



class _MyAppState extends State<MyApp>  with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationServices.initialize(context);

    FirebaseMessaging.onMessage.listen(firebaseMessagingonmessageHandler);

    FirebaseMessaging.onBackgroundMessage.call(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessagingonmessageOpenedAppHandler);

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      //super.didChangeAppLifecycleState(state);
      switch (state) {
        case AppLifecycleState.resumed:
          setState(() {});
          break;
        case AppLifecycleState.inactive:
          NotificationServices().setUserState(status: "Offline");
          break;
        case AppLifecycleState.paused:
          NotificationServices().setUserState(status: "Waiting");
          break;
        case AppLifecycleState.detached:
          NotificationServices().setUserState(status: "Offline");
          break;
        default:
          break;
      // TODO: Handle this case.
      }
    } catch (e) {
      if (kDebugMode) {
        print('inside catch statement');
      }
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color.fromRGBO(213, 97, 132, 1),
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Checkconnection(),
      builder: InAppNotifications.init(),
    );
  }
}


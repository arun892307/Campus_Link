import 'dart:convert';
import 'package:campus_link_teachers/push_notification/helper_notification.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Registration/no_internet.dart';
import 'Screens/Main_page.dart';
import 'package:http/http.dart' as http;

class Checkconnection extends StatelessWidget {
  Checkconnection({Key? key}) : super(key: key);
  Connectivity connectivity=Connectivity();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ConnectivityResult>(
          stream: connectivity.onConnectivityChanged,
          builder: (_,snapshot){
            return Internetcheck(snapshot: snapshot, widget: const MainPage(),);
          }
      ),
    );
  }
}

class Internetcheck extends StatefulWidget {
  final AsyncSnapshot<ConnectivityResult> snapshot;
  final Widget widget;
  const Internetcheck({Key? key, required this.snapshot, required this.widget}) : super(key: key);

  @override
  State<Internetcheck> createState() => _InternetcheckState();
}

class _InternetcheckState extends State<Internetcheck> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // if(!kIsWeb){
    //   NotificationServices().RequestPermission();
    // }
  }


  void sendPushMessage(String token, String body,String title) async{
    try{
      await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String ,  String>{
            'Content-Type' : "application/json",
            "Authorization":  "key=AAAAIV7WaYA:APA91bFtEFPpqZBF3z1FeRD6CmhYYrtA2EX7Y7oGCf2qjAHLKcyi15Dbd7e3Cjo3WS1rKeHCzS_07fUfUsV6jnTJ7uZiHy2z8h-CIRW9jjO2jxycobLjgrI7nVT76-mUt8Dd41psJ_oI"
          },
          body: jsonEncode(<String,dynamic>{
            'priority': 'high',
            "data": <String,dynamic>{
              'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
              'status':"done",
              'body': body,
              'title':title,
            },
            // "notification":<String,dynamic>{
            //   'body': body,
            //   'title':title,
            //   'android_channel_id':"high_importance_channel"
            // },
            "to": token
          })
      );
    }catch(e){

    }
  }

  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return widget.widget;
    }
    switch(widget.snapshot.connectionState){
      case ConnectionState.active:
        final state = widget.snapshot.data!;
        switch(state){
          case ConnectivityResult.none:
            print("......none");
            return const No_internet();
          case ConnectivityResult.bluetooth:
            return const Center(child: Text("You are not connected to internet... you are connected to bluetooth"));
          case ConnectivityResult.ethernet:
            return widget.widget;
          case ConnectivityResult.mobile:
            return widget.widget;
          case ConnectivityResult.wifi:
            return widget.widget;
          default:
            return const Center(child:Text("oops Gand marao error"));
        }
      default:
        print("..............here");
        return const No_internet();
    }
  }
}

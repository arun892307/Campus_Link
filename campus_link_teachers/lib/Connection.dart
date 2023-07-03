import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'Screens/Main_page.dart';

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
  @override
  Widget build(BuildContext context) {
    switch(widget.snapshot.connectionState){
      case ConnectionState.active:
        final state = widget.snapshot.data!;
        switch(state){
          case ConnectivityResult.none:
            return const Center(child: Text("Not connected"));
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
        return const Center(
          child: Text("hurr garib net pack dalvao"),
        );
    }
  }
}

import 'package:flutter/material.dart';

class Sessional extends StatefulWidget {
  const Sessional({Key? key}) : super(key: key);

  @override
  State<Sessional> createState() => _SessionalState();
}

class _SessionalState extends State<Sessional> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text("Sessional marks")
      ),
    );
  }
}

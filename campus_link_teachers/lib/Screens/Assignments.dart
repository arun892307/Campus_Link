import 'package:flutter/material.dart';

class Assignments_upload extends StatefulWidget {
  const Assignments_upload({Key? key}) : super(key: key);

  @override
  State<Assignments_upload> createState() => _Assignments_uploadState();
}

class _Assignments_uploadState extends State<Assignments_upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Assignment"),
            ],
          ),
        ),
      ),
    );
  }
}

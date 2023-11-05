import 'dart:io';

import 'package:flutter/material.dart';

class Image_viewer extends StatelessWidget {
  const Image_viewer({super.key, required this.path});
  final File path ;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: CircleAvatar(
        radius: size.width*0.05,
        backgroundColor: Colors.black.withOpacity(0.5),
        child: IconButton(
          onPressed: (){
            Navigator.pop(context);
            },
          icon: const Icon(Icons.clear),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(path),fit: BoxFit.contain)
        ),
      ),
    );
  }
}

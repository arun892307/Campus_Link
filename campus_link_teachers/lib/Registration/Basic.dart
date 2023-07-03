import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../Database/database.dart';


class basicDetails extends StatefulWidget {
  const basicDetails({Key? key}) : super(key: key);

  @override
  State<basicDetails> createState() => _basicDetailsState();
}

class _basicDetailsState extends State<basicDetails> {
  final _key = GlobalKey<FormState>();
  final List<TextFormField> _universityFields = [];
  final List<TextEditingController> _universitycontroller = [];
  final List<List<TextEditingController>> _coursecontroller = [[]];
  final List<List<TextFormField>> _courseFields = [[]];

  final textStyle = GoogleFonts.alegreya(fontSize: 28, fontWeight: FontWeight.w900,color: Colors.amber,
    shadows: <Shadow>[
      const Shadow(
        offset: Offset(1, 1),
        color: Colors.black,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg-image.png"),
              fit: BoxFit.cover
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.04,
              0,
              MediaQuery.of(context).size.width * 0.04,
              0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText('Welcome To Campus Link',

                      textStyle: textStyle
                  ),

                ],
                repeatForever: true,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.black,width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 10,
                          blurStyle: BlurStyle.outer,
                          color: Colors.black26,
                          offset: Offset(1, 1)
                      )
                    ]
                ),
                height: MediaQuery.of(context).size.height*0.89,
                width: MediaQuery.of(context).size.width*0.99,
                child: Column(
                  children: [
                    Expanded(child: _universitylistview()),
                    _universityaddtile()
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
  Widget _universityaddtile() {
    return ListTile(
      title: const Center(child: Text('Add University',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),)),
      onTap: () {
        final controller = TextEditingController();
        final field = TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'University cannot be empty';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    int index=_universitycontroller.indexOf(controller);
                    _universitycontroller.removeAt(index);
                    _universityFields.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
                color: Colors.black,
              ),
              labelText: "University ${_universitycontroller.length + 1}",
              labelStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700)),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        );
        setState(() {
          _universitycontroller.add(controller);
          _universityFields.add(field);
        });
      },
    );
  }

  Widget _universitylistview() {
    ScrollController listScrollController = ScrollController();
    if(listScrollController.hasClients){
      setState(() {
        final position = listScrollController.position.maxScrollExtent;
        listScrollController.jumpTo(position);
      });
    }
    return ListView.builder(
      controller: listScrollController,
      itemCount: _universityFields.length,
      itemBuilder: (context, index) {
        return Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.8),
                border: Border.all(color: Colors.black,width: 1.5),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      color: Colors.black26,
                      offset: Offset(1, 1)
                  )
                ]
            ),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                _universityFields[index],
                Container(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  height: 280,
                  child: Expanded( child: _courselistview(index),),
                ),
                _courseaddtile(index)

              ],
            )
        );
      },
    );
  }

  Widget _courseaddtile(int index) {
    return ListTile(
      title: const Center(child: Text('Add Course',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),)),
      onTap: () {
        final controller = TextEditingController();
        final field = TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Course cannot be empty';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    int index=_universitycontroller.indexOf(controller);
                    _universitycontroller.removeAt(index);
                    _universityFields.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
                color: Colors.black,
              ),
              labelText: "Course ${_coursecontroller.length + 1}",
              labelStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700)),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        );
        setState(() {
          _coursecontroller.add([]);
          _courseFields.add([]);
          _coursecontroller[index].add(controller);
          _courseFields[index].add(field);
        });
        print("${_coursecontroller.length}");
      },
    );
  }

  Widget _courselistview(int inde) {
    ScrollController listScrollController = ScrollController();
    if(listScrollController.hasClients){
      setState(() {
        final position = listScrollController.position.maxScrollExtent;
        listScrollController.jumpTo(position);
      });
    }
    return ListView.builder(
      controller: listScrollController,
      itemCount: _courseFields.length,
      itemBuilder: (context, index) {
        return Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.8),
                border: Border.all(color: Colors.black,width: 1.5),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      color: Colors.black26,
                      offset: Offset(1, 1)
                  )
                ]
            ),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                _courseFields[inde][index],
                Container(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  height: 280,
                  child: const Expanded( child: Text("Branch"),),
                ),
                //add branch tile

              ],
            )
        );
      },
    );
  }


  Future upload(String naam,String section) async{
    try{
      Position x= await database().getloc() ;
      await FirebaseFirestore.instance.collection("Students").doc(FirebaseAuth.instance.currentUser!.email).set(
          {
            "Name" : naam,
            'Section': section,
            'Location' : GeoPoint(x.latitude, x.longitude)
          });
    }
    on FirebaseAuthException catch (e){
      InAppNotifications.instance
        ..titleFontSize = 14.0
        ..descriptionFontSize = 14.0
        ..textColor = Colors.black
        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
        ..shadow = true
        ..animationStyle = InAppNotificationsAnimationStyle.scale;
      InAppNotifications.show(
          title: 'Failed',
          duration: const Duration(seconds: 2),
          description: e.toString().split(']')[1].trim(),
          leading: const Icon(
            Icons.error_outline_outlined,
            color: Colors.red,
            size: 55,
          )
      );
    }
  }

}

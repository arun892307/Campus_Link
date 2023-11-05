/*


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart'  hide BoxDecoration, BoxShadow;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' ;//hide BoxDecoration, BoxShadow;


class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.06,
          ),
          */
/*Container(
            height: size.height * 0.073,
            width: size.width,
            margin: EdgeInsets.only(
                left: size.height * 0.009, right: size.height * 0.009),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              border: Border.all(
                color: Colors.transparent,
              ),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(169, 169, 207, 1),
                  // Color.fromRGBO(86, 149, 178, 1),
                  Color.fromRGBO(189, 201, 214, 1),
                  //Color.fromRGBO(118, 78, 232, 1),
                  Color.fromRGBO(175, 207, 240, 1),

                  // Color.fromRGBO(86, 149, 178, 1),
                  Color.fromRGBO(189, 201, 214, 1),
                  Color.fromRGBO(169, 169, 207, 1),
                ],
              ),
            ),
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: Colors.transparent,
                elevation: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.menu_sharp)),
                    AutoSizeText("Campus Link",
                        style: GoogleFonts.openSans(
                            fontSize: 25,
                            fontWeight: FontWeight.w500
                        )),
                    SizedBox(
                      width: size.width*0.2,
                    ),
                    IconButton(onPressed: () {},
                        icon:  Icon(Icons.send,size: size.height*0.034,)),
                    IconButton(onPressed: () {},
                        icon:  Icon(Icons.filter_alt,size: size.height*0.034))
                  ],
                ),
              ),
            )

          ),*//*



          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: size.height*0.24,
            width: size.width*0.2,
            decoration: BoxDecoration(
              //color: Colors.black26,
                borderRadius:BorderRadius.circular(30) ,
                boxShadow:   const [
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(20,20),
                      blurRadius:30.0,
                      inset:false
                  ),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-20,-20),
                      blurRadius: 30.0,
                      inset: false
                  )

                ]
            ),

          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: size.height*0.12,
        color: Colors.black26,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
        AnimatedContainer(
            duration: Duration(milliseconds: 300),
        height: size.height*0.1,
        width: size.width*0.2,
        decoration: BoxDecoration(
            //color: Colors.black26,
            borderRadius:BorderRadius.circular(30) ,
            boxShadow:   [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(20,20),
                  blurRadius:30.0,
               // inset:false
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-20,-20),
                blurRadius: 30.0,
                //inset: false
              )

            ]
        ),

      ),
          ],
        )
      )

    );
  }
}
*/

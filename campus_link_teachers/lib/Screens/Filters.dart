import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../Database/database.dart';
import 'Main_page.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

enum SingingCharacter { Maths, DBMS }

class _FiltersState extends State<Filters> {
  SingingCharacter? _character = SingingCharacter.Maths;
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: const Text("Filters"),
        titleTextStyle: TextStyle(
            color: const Color.fromRGBO(150, 150, 150, 1),
            fontWeight: FontWeight.w900,
            fontSize: MediaQuery.of(context).size.height * 0.03),
      ),


      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 20,
                  backgroundColor: const Color.fromRGBO(150, 150, 150, 1)),
              onPressed: () async {

                subject=_character.toString().split('.')[1];
                student_id.clear();
                await database().filter();
                await database().student_locationmap_email();
                print("${instance_of_student_doc.docs}");
                Navigator.pop(context);
              },
              child: const Text(
                "Apply",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),


      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: const Color.fromRGBO(60, 60, 60, 1),
                          width: MediaQuery.of(context).size.width * 0.008))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filters",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.01,
                        ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      },
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Color.fromRGBO(150, 150, 150, 1),
                  ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  title: const Text('Maths'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.Maths,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('DBMS'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.DBMS,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),


    );
  }
}

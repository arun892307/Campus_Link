import 'dart:async';

import 'package:flutter/material.dart';
import '../Database/database.dart';
class SelectedStudents extends StatefulWidget {
  const SelectedStudents({Key? key}) : super(key: key);

  @override
  State<SelectedStudents> createState() => _SelectedStudentsState();
}

class _SelectedStudentsState extends State<SelectedStudents> {
  bool button_enabled=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(milliseconds: 0), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: activestudentslistview()),
            Container(
              height: MediaQuery.of(context).size.height*0.05,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.amber,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 15
                    )
                  ]
              ),
              margin: EdgeInsets.all(MediaQuery.of(context).size.height*0.01,),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                          color: Colors.amber
                      ),
                      shape: const StadiumBorder(),
                      backgroundColor: const Color.fromRGBO(55, 55, 55, 1)
                  ),
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
                      title: const Text("Confirm",style: TextStyle(color: Colors.white)),
                      content: const Text("Are you sure? To mark Attendance",style: TextStyle(color: Colors.white)),
                      shadowColor: Colors.amberAccent,
                      backgroundColor: const Color.fromRGBO(55, 55, 55, 1),
                      elevation: 100,
                      actions: [
                        TextButton(
                          onPressed: () {
                            database().markAttendance();
                            Navigator.pop(context);
                            database().attendanceDone();
                          },
                          child: const Text("Yes",style: TextStyle(color: Colors.green)),
                        ),
                        TextButton(
                          onPressed: (){ Navigator.pop(context);},
                          child: const Text("No",style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ));
                  },
                  child: const Text("Mark as Present")),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.01,
            )
          ],
        ),
      ),
    );
  }
  Widget activestudentslistview() {
    ScrollController listScrollController = ScrollController();
    if(listScrollController.hasClients){
      setState(() {
        final position = listScrollController.position.maxScrollExtent;
        listScrollController.jumpTo(position);
      });
    }
    return ListView.builder(

      controller: listScrollController,
      itemCount: distanceList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromRGBO(12, 12, 12, 1),
              border: Border.all(color: Colors.black,width: 1.5),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6,
                  blurStyle: BlurStyle.outer,
                  color: Colors.amber,
                  offset: Offset(0, 0),
                )
              ]
          ),
          margin: const EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height * 0.07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Text(allstudentsname[distanceList[index]]![0],style: const TextStyle(color: Colors.white)),
                  Text(allstudentsname[distanceList[index]]![1],style: const TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.03,
                  ),
                  IconButton(
                      onPressed: (){
                        active_student_email.remove(distanceList[index]);
                        distanceList.remove(distanceList[index]);
                        },
                      icon: const Icon(Icons.clear_outlined,color: Colors.red,))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

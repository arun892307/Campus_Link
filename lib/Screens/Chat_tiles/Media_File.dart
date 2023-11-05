
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Media_files extends StatefulWidget {
  const Media_files({Key? key, required this.channel}) : super(key: key,);
  final String channel;

  @override
  State<Media_files> createState() => _Media_filesState();
}

class _Media_filesState extends State<Media_files> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading:IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)
        ),
        backgroundColor: Colors.black38,
        title: Text("${widget.channel}"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.grey,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Messages").doc(widget.channel).snapshots(),
          builder:(context, snapshot) {
            return snapshot.hasData
                ?
            GridView.builder(
              padding: EdgeInsets.all(size.width*0.02),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                  crossAxisSpacing:size.width*0.012,
              mainAxisSpacing: size.width*0.012),
              itemCount:snapshot.data!.data()?["Media_Files"].length ,
              itemBuilder:(context, index) {
                return InkWell(
                  onTap: (){
                    // snapshot.data!.data()?["Media_Files"][index]["Video"]
                    //     ?
                    //     null
                    //     :
                    // Navigator.push(
                    //   context,
                    //   PageTransition(
                    //       childCurrent:Media_files(channel: widget.channel,),
                    //       child:Image_viewer(url: snapshot.data!.data()?["Media_Files"][index]["Image_URL"]),
                    //       type: PageTransitionType
                    //           .rightToLeftJoined,
                    //       duration: const Duration(
                    //           milliseconds: 300)),
                    // );
                  },
                  child: Container(
                      height: size.height*0.1,
                      width: size.width*0.3,
                    decoration:snapshot.data!.data()?["Media_Files"][index]["Video"]
                      ?
                     BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            image: NetworkImage(snapshot.data!.data()?["Media_Files"][index]["Video_Thumbnail_URL"]),
                            fit: BoxFit.contain
                        )
                    )
                        :
                    BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            image: NetworkImage(snapshot.data!.data()?["Media_Files"][index]["Image_URL"]),
                            fit: BoxFit.contain
                        )
                    ),
                    child: Center(
                      child: snapshot.data!.data()?["Media_Files"][index]["Video"]
                      ?
                      CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: size.width*0.04,
                          child: Icon(Icons.play_arrow,color: Colors.white60,size: size.width*0.06,))
                          :
                      const SizedBox()
                    ),

                  ),
                );
              },
            )
                :
            SizedBox();
          },
        ),
      ),
    );
  }
}

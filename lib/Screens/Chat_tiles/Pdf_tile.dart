import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'PdfViewer.dart';

class PdfTile extends StatefulWidget {
  const PdfTile({Key? key, required this.pdfUrl, required this.pdfImageUrl, required this.stamp, required this.size, required this.name}) : super(key: key);

  final String pdfUrl;
  final String pdfImageUrl;
  final DateTime stamp;
  final int size;
  final String name;


  @override
  State<PdfTile> createState() => _PdfTileState();
}

class _PdfTileState extends State<PdfTile> {
  final dio=Dio();
  bool _downloaded = false;
  File _pdfPath=File("");
  File _imagePath=File("");

  int downloadTaskStatus = 0;
  bool downloaded=false;
  double percent= 0;
  bool isDownloading = false;
  @override
  void initState() {
    super.initState();
    _downloaded
        ?
    null
        :
    check();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _downloaded
        ?
    Column(
      children: [
        SizedBox(height: size.height*0.01,),
        InkWell(
          onTap: () {
            if(downloaded){
              Navigator.push(
                context,
                PageTransition(
                  child: PdfViewer(document: _pdfPath.path,name: widget.name),
                  type: PageTransitionType.bottomToTopJoined,
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.bottomCenter,
                  childCurrent: PdfTile(
                    size: widget.size,
                    pdfUrl: widget.pdfUrl,
                    name: widget.name,
                    pdfImageUrl: widget.pdfImageUrl,
                    stamp: widget.stamp,
                  ),
                ),
              );
            }

          },
          child: Container(
            width: size.width*0.7,
            height: size.height*0.3,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: FileImage(_imagePath),
                fit: BoxFit.contain,
              ),
            ),
            child: downloaded
                ?
            const SizedBox()
                :
            isDownloading
                ?
            CircularPercentIndicator(
              percent: percent,
              radius: size.width*0.08,
              animation: true,
              animateFromLastPercent: true,
              curve: accelerateEasing,
              progressColor: Colors.green,
              center: Text("${(percent*100).toDouble().toStringAsFixed(2)}%"),
              footer: const Text("Downloading"),
              backgroundColor: Colors.transparent,
            )
                :
            IconButton(
                onPressed: (){
                  downloadPdf();
                  setState(() {
                    isDownloading=true;
                  });
                },
                icon: const Icon(Icons.download)
            ),
          ),
        ),
        Container(
          height: size.height*0.07,
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: size.width*0.02,),
              SizedBox(
                  height: size.height*0.04,
                  child: const Image(image: AssetImage("assets/images/pdf.png"))),
              SizedBox(width: size.width*0.015,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width*0.44,
                    child: AutoSizeText(
                        widget.name,
                      style: GoogleFonts.openSans(
                          color: Colors.white,
                        fontSize: size.width*0.045,
                        fontWeight: FontWeight.w500
                      ),
                      //minFontSize: 15,
                    ),

                  ),

                  SizedBox(
                    width: size.width*0.44,
                    child: AutoSizeText(
                    "${(widget.size/1048576).toStringAsFixed(2)} MB",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: size.width*0.025,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
              downloaded
                  ?
              const SizedBox()
                  :
              IconButton(
                  onPressed: (){
                    downloadPdf();
                    setState(() {
                      isDownloading=true;
                    });
                  },
                  icon: Icon(
                    Icons.download,
                    color: Colors.green,
                    size: size.width*0.07,
                  )
              ),

          ],
          ),
        ),
      ],
    )
        :
    const SizedBox();
  }

  check() async {
    try{
      Directory? directory = await getApplicationSupportDirectory();
      String additionalPath= "/doc";
      String additionalPath1= "/thumbnail";
      Directory directory1 = Directory("${directory.path}$additionalPath1");

      directory = Directory("${directory.path}$additionalPath");
      _pdfPath=File("${directory.path}/${widget.stamp.toString().split(".")[0]}/${widget.name}");
      File imgPath=File("${directory1.path}/${widget.stamp.toString().split(".")[0]}.png");
      if(await _pdfPath.exists()){
        print("pdf exist original");
        setState(() {
          _imagePath = imgPath;
          _downloaded=true;
          downloaded=true;
        });
      }

      else{
        print("original pdf not exist");
        directory = await getApplicationSupportDirectory();
        additionalPath= "/thumbnail";
        directory = Directory("${directory.path}$additionalPath");

        if(directory.existsSync()){
          print("Directory exist");
        }
        else{
          print("thumbnail not exist");
          await directory.create();
        }

        File imgpath=File("${directory.path}/${widget.stamp.toString().split(".")[0]}.png");
        print("...............${widget.stamp}");
        if(await imgpath.exists()){

          print("pdf exist thumbnail image");
          setState(() {
            _imagePath=imgPath;
            _downloaded=true;
          });
        }
        else{
          print("Downloading pdf thumbnail");
          //await  imgpath.create(recursive: true);
          try{
            await dio.download(widget.pdfImageUrl, imgpath.path,onReceiveProgress: (count, total) {
              if(count==total){
                setState(() {
                  _imagePath=imgPath;
                  _downloaded=true;
                });
              }
            },);
          }
          catch (e) {
            print(".................................................$e");
          }

        }
      }
    }catch (e){
      print("error from here $e");
    }




  }



  downloadPdf() async {
    Directory? directory = await getApplicationSupportDirectory();
    String additionalPath= "/doc";
    directory = Directory("${directory.path}$additionalPath");

    if(directory.existsSync()){
      print("Directory exist");
    }
    else{
      await directory.create();
    }

    File pdf=File("${directory.path}/${widget.stamp}/${widget.name}");



    await dio.download(widget.pdfUrl,pdf.path,onReceiveProgress: (count, total) {
      if(count==total){
        setState(() {
          _pdfPath=pdf;
          downloaded=true;
        });
      }
      else{
        setState(() {
          isDownloading=true;
          percent = (count/total);
        });
      }
    },);

  }
}

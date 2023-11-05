
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfx/pdfx.dart';

import '../loadingscreen.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({Key? key, required this.document, required this.name}) : super(key: key);

  final String document;
  final String name;
  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PdfController pdfControllers;
  bool initialized = false;
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      pdfControllers= PdfController(document: PdfDocument.openFile(widget.document));
      setState(() {
        initialized=true;
      });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: size.width*0.13,
          titleSpacing: 0,
          leading: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: const Icon(
                  Icons.arrow_back_ios_new)),
          centerTitle: false,
          title: AutoSizeText(
            widget.name,
            style: GoogleFonts.exo(
                color: Colors
                    .white,
                fontSize:
                size.width *
                    0.06),
            minFontSize: 8,
            maxLines: 1,
          )
      ),
      body: initialized
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.01,
          ),
          // load
          //     ? SizedBox(
          //         height: size.height * 0.15,
          //         child: ListView.builder(
          //
          //           scrollDirection: Axis.horizontal,
          //           itemCount: imageBytes.length,
          //           itemBuilder: (context, index) {
          //             return InkWell(
          //               onTap: () {
          //                 setState(() {
          //                   pdfIndex=index;
          //                 });
          //               },
          //               child: Container(
          //                 height: size.height * 0.2,
          //                 width: size.width * 0.3,
          //                 decoration: BoxDecoration(
          //                     color: Colors.black,
          //                     image: DecorationImage(
          //                         image: MemoryImage(imageBytes[index]),
          //                         fit: BoxFit.contain)),
          //               ),
          //             );
          //           },
          //         ),
          //       )
          //     : const SizedBox(),
          Expanded(
            child: PdfView(

              scrollDirection: Axis.vertical,
              controller: pdfControllers,
            ),
          ),
        ],
      )
          : const loading(
        text: 'Loading Pdf please wait',
      ),
    );
  }

}

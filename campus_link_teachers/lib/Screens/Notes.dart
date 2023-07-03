import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> file_details = [];

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final FirebaseFirestore _firebaseinstance = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch_all_files();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    resizeToAvoidBottomInset: false,
    extendBodyBehindAppBar: false,
      backgroundColor: const Color.fromRGBO(28, 280, 28, 1),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: file_details.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Pdf_viewer(URL: file_details[index]["URL"])));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black38,
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  color: Colors.grey,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.yellow,
                      blurRadius: 10
                    )
                  ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/images/pdf_icon.png",
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: Text(
                        file_details[index]["name"],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload_file),
        onPressed: () {
          selectfile();
        },
      ),
    );
  }

  Future<String> Upload_file(String filename, File file) async {
    final refrence = FirebaseStorage.instance.ref().child("CN/$filename.pdf");
    final upload_status = refrence.putFile(file);
    await upload_status.whenComplete(() => print("Sucessfully uploaded"));
    final downloadlink = await refrence.getDownloadURL();
    return downloadlink;
  }

  void selectfile() async {
    final selected_file = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (selected_file != null) {
      String filename = selected_file.files[0].name;
      File file = File(selected_file.files[0].path!);
      final downloadlink = await Upload_file(filename, file);
      await _firebaseinstance.collection("Notes").add({
        "name": filename,
        "URL": downloadlink,
      });
    } else {
      print("No File selected yet");
    }
    setState(() {
      fetch_all_files();
    });
  }

  void fetch_all_files() async {
    final files = await _firebaseinstance.collection("Notes").get();
    file_details = files.docs.map((e) => e.data()).toList();
    setState(() {});
  }
}

class Pdf_viewer extends StatefulWidget {
  String URL;
  Pdf_viewer({Key? key, required this.URL}) : super(key: key);

  State<Pdf_viewer> createState() => _Pdf_viewerState();
}

class _Pdf_viewerState extends State<Pdf_viewer> {
  PDFDocument? document;
  void access_pdf() async {
    document = await PDFDocument.fromURL(widget.URL);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    access_pdf();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: document != null
            ? PDFViewer(
                document: document!,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

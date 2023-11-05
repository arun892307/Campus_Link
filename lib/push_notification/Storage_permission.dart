

import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class CheckPermission{
  Future<bool> isStoragePermission() async {
    var isStorage = await Permission.storage.status;
    var isAccessLc = await Permission.accessMediaLocation.status;
    var isManageExt = await Permission.manageExternalStorage.status;
    if(!isStorage.isGranted || !isAccessLc.isGranted || !isManageExt.isGranted ){
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      await Permission.accessMediaLocation.request();
      if(!isStorage.isGranted || !isAccessLc.isGranted || !isManageExt.isGranted){
        return false;
      }
    }
    return true;
  }
}

class DirectoryPath {
  getPath() async {
    final path = Directory("/storage/emulated/0/Android/data/com.campus.link.techer/");
    if(await path.exists()){
    }
    else{
    path.create();
    }
    return path.path;
  }
}
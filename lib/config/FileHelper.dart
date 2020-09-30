import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileHelper{

  static Future<bool> writeImage(Uint8List bytes, {int memberId,Function callback}) async {

    final Directory extDir = (await getExternalStorageDirectory());
    final String dirPath = '${extDir.path}images';

    Directory directory = await Directory(dirPath).create(recursive: true);
    final String filePath = '${dirPath}/${timestamp()}.jpg';


    File f = File(filePath);
    f.writeAsBytesSync(bytes);

    if(callback != null){
      callback(filePath,memberId,sync:true);
    }

  }

  static String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  static Future<bool> hasPermission() async {
    PermissionStatus storagePermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    Map<PermissionGroup,PermissionStatus> map;
    if (PermissionStatus.denied == storagePermission) {
      map = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);

//       print(map);
    }
    PermissionStatus cameraPermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (PermissionStatus.denied == cameraPermission) {
      map = await PermissionHandler()
          .requestPermissions([PermissionGroup.camera]);

//      print(map);
    }
  }



}
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/DepositData.dart';
import 'package:nupms_app/widgets/ToastMessage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => _CameraScreenState();

}

class _CameraScreenState extends State<CameraScreen>{
  CameraController controller;
  String imagePath;


  List<CameraDescription> cameras = [];

  void loadCamera() async {
    var _cameras = await availableCameras();
    controller = CameraController(
        _cameras[0],
      ResolutionPreset.low,
      enableAudio: false
    );

    if(mounted) {
      controller.initialize().then((_){
        setState(() { });
      });

    }
  }

  @override
  void initState() {
    super.initState();

    loadCamera();
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> args = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Column(

          children: <Widget>[

            Expanded(
                child:Container(

                    child:Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Center(
                            child:_cameraPreviewWidget()
                        )
                    )
                )
            ),
            _captureControlRowWidget(args),
            Padding(
                padding: EdgeInsets.all(5.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _thumbnailWidget()
                  ],
                )
            )
          ],
        ),
      ),
    ) ;
  }

  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child:Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            imagePath == null?
              Container():
              SizedBox(
                child: Image.file(File(imagePath)),
                width: 64.0,
                height: 64.0,
              )
          ],
        )
      )
    );
  }

  Widget _cameraPreviewWidget() {
    if(controller == null || !controller.value.isInitialized){
      return Text(
        "Tap a Camera",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w800
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width-130,

        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      );
    }
  }

  Widget _captureControlRowWidget(dynamic args){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.camera,color: Colors.white,),
              Text(" Photo",style: TextStyle(color: Colors.white),
              )
            ],
          ),


          color: Colors.blue,
          onPressed: () async{
            if(controller != null && controller.value.isInitialized &&
            !controller.value.isRecordingPaused){
              await handleSnapshot(args);
              context.read<DepositData>().setSlipImagePath(imagePath);
              Navigator.pop(context);
            }
          },
        ),

      ],
    );
  }

  void handleSnapshot(dynamic args,{int type}) async{
    String filePath = await takePicture();
    if(mounted){
      setState(() {
        imagePath = filePath;

      });
    }
  }

  Future<String> takePicture() async {
//    MethodChannel platform = MethodChannel("nupms/writefile");
    if(!controller.value.isInitialized){
      ToastMessage.showMesssage(status:500,message:"Error. select a camera first.", context:context);
      return null;
    }

    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (PermissionStatus.denied == permission) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
    }

    final Directory extDir = (await getExternalStorageDirectory());
    final String dirPath = '${extDir.path}/images';

    Directory directory = await Directory(dirPath).create(recursive: true);


    final String filePath = '${dirPath}/${timestamp()}.jpg';
//    return filePath;

    if(controller.value.isTakingPicture){
      return null;
    }

    try{

      await controller.takePicture(filePath);
//      platform.invokeMethod("scanFile",{"path":filePath});




    }on CameraException catch(e){
      ToastMessage.showMesssage(status:500,message:e.description, context:context);
      return null;
    }
    return filePath;
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
}
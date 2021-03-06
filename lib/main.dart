import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nupms_app/config/FileHelper.dart';
import 'package:nupms_app/config/portrait_mode_mixin.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/DepositData.dart';
import 'package:nupms_app/model/LoginDataNotifier.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:nupms_app/model/ScheduleData.dart';
import 'package:nupms_app/model/UploadCollectionData.dart';
import 'package:nupms_app/screens/DashboardScreen.dart';
import 'package:nupms_app/screens/LoginScreen.dart';
import 'package:nupms_app/screens/SplashScreen.dart';
import 'package:provider/provider.dart';


void main() {

  

  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider<AppData>( create: (context) => AppData()),
        ChangeNotifierProvider<PaybackCollectionData>( create: (context) => PaybackCollectionData()),
        ChangeNotifierProvider<ScheduleData>( create: (context) => ScheduleData()),
        ChangeNotifierProvider<DepositData>( create: (context) => DepositData()),
        ChangeNotifierProvider<UploadCollectionData>( create: (context) => UploadCollectionData()),
        ChangeNotifierProvider<LoginDataNotifier>( create: (context) => LoginDataNotifier())
      ],
      child:MyApp()));
}

class MyApp extends StatelessWidget with PortraitModeMixin {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nupms',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: switchScreen(context),

      debugShowCheckedModeBanner: false,
    );
  }

  Widget switchScreen(BuildContext context){

    if(!context.watch<AppData>().isAppLoaded){
      return SplashScreen();
    }
    if(context.watch<AppData>().user !=null){
      if(!context.watch<AppData>().user.downloadMaster) {
        return DashboardScreen();
      }
    }
    
    return LoginScreen();
  }


}





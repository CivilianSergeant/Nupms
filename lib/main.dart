import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:nupms_app/screens/DashboardScreen.dart';
import 'package:nupms_app/screens/LoginScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider<AppData>( create: (context) => AppData()),
        ChangeNotifierProvider<PaybackCollectionData>( create: (context) => PaybackCollectionData())
      ],
      child:MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numps',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: switchScreen(context),

      debugShowCheckedModeBanner: false,
    );
  }

  Widget switchScreen(BuildContext context){

    if(context.watch<AppData>().isLoggedIn){
      return DashboardScreen();
    }
    return LoginScreen();
  }
}





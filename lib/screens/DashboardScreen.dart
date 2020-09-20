import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/persistance/entity/User.dart';
import 'package:nupms_app/persistance/repository/UserRepository.dart';
import 'package:nupms_app/persistance/services/MemberService.dart';
import 'package:nupms_app/persistance/services/UserService.dart';
import 'package:nupms_app/widgets/BadgeTile.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/Sidebar.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:nupms_app/widgets/WelcomeCard.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {


  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String _title = "NUPMS";
  int entNumbers = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TitleBar(elevation: 0,).build(context),
      drawer: Sidebar(name:context.watch<AppData>().user.employeeName),
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(

          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: CardView(
                    baseHeight:108,
                    text: "Welcome",
                    contentHeight: 38,
                    background: Colors.indigoAccent,
                    card: WelcomeCard(),
                    contentBackground:Colors.transparent
                  )),
              Row(
                children: [
                  BadgeTile(text: "Entrepreneurs Count",amount:context.watch<AppData>().totalEnts.toString(),color: Colors.white,),
                  BadgeTile(text: "Collected Amount",amount:context.watch<AppData>().totalCollectedAmount.toString(),color: Colors.white,)
                ],
              )
            ],
          )

      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    loadInfo();
    Future.delayed(Duration(milliseconds: 10),(){
      context.read<AppData>().changeTitle(_title);
    });

  }

  loadInfo() async{
    int totalEnts = await MemberService.getMembersCount();

    context.read<AppData>().setDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    UserService userService = UserService(userRepo: UserRepository());
    User user = await userService.checkCurrentUser();

    context.read<AppData>().setUser(user);
    context.read<AppData>().setTotalEnts(totalEnts);
    context.read<AppData>().updateTotalCollection(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

}
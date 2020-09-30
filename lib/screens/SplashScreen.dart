import 'package:flutter/material.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/config/FileHelper.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/persistance/DbProvider.dart';
import 'package:nupms_app/persistance/entity/User.dart';
import 'package:nupms_app/persistance/repository/UserRepository.dart';
import 'package:nupms_app/persistance/services/UserService.dart';
import 'package:nupms_app/widgets/RoundedButton.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation<Color> colorAnimation;
  Animation<double> tweenAnimation;
  double logoTop=0;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(duration: Duration(seconds: 5),vsync: this);
    ColorTween ct = ColorTween(begin:Colors.white, end:Colors.indigo);
    Tween<double> tween = Tween<double>(begin: 0.0,end: 1.0);
    colorAnimation = ct.animate(animationController);
    tweenAnimation = tween.animate(animationController);

    animationController.addStatusListener((status) {

      if(status == AnimationStatus.completed){
        animationController.reverse();
      }else if(status == AnimationStatus.dismissed){
        animationController.forward();
      }

    });
    animationController.addListener(() {
      setState(() {});
    });
    animationController.forward();

    initDb();
  }

  Future<void> initDb() async {
    FileHelper.hasPermission();

    AppConfig.log("HERE INIT DB");
    final Database db = await DbProvider.db.database;
    UserService userService = UserService(userRepo: UserRepository());
    User user = await userService.checkCurrentUser();
    
    if(user !=null ){
      context.read<AppData>().setUser(user);
    }
    context.read<AppData>().setAppLoaded(true);

  }



  @override
  Widget build(BuildContext context) {

    logoTop = (MediaQuery.of(context).size.width/2.0);

    double userNameTop = 20;
    double passwordTop = userNameTop+10;
    double actionButtonTop = passwordTop+10;

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
        child: Stack(
          children:[
            Opacity(
              opacity: 1,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset('images/1.jpg',fit: BoxFit.cover,)
              ),
            ),
            Opacity(
              opacity: tweenAnimation.value,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset('images/2.jpg',fit: BoxFit.cover,)
              ),
            ),
            Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top:logoTop),
                  child: Text("NUPMS", style: TextStyle(
                    fontSize: 35,
                    color: colorAnimation.value,
                    fontWeight: FontWeight.bold
                  ),),
                ),

                SizedBox(height:50,),
                SizedBox(

                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colorAnimation.value),
                  )
                )


              ],
            ),
          ),

          ],
        ),
      ),
    );
  }



  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}


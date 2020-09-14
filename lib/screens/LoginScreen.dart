import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/widgets/RoundedButton.dart';
import 'package:nupms_app/widgets/RoundedTextField.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {



  @override
  State<StatefulWidget> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation<Color> colorAnimation;
  Animation<double> tweenAnimation;
  double logoTop=0;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

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

  }



  @override
  Widget build(BuildContext context) {

    logoTop = (MediaQuery.of(context).size.width/2.0);

    double userNameTop = 20;
    double passwordTop = userNameTop+10;
    double actionButtonTop = passwordTop+10;

    return Scaffold(
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
                  child: Text("NUMPS", style: TextStyle(
                    fontSize: 35,
                    color: colorAnimation.value,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                RoundedTextField(hintText:"Username",topMargin: userNameTop, controller: username ,),
                RoundedTextField(hintText:"Password",topMargin: 5,isObscure: true,obscuringChar: '*',controller: password ,),
                SizedBox(height:50,),
                SizedBox(

                  width: MediaQuery.of(context).size.width-40,
                  child:RoundedButton(
                    text: "LOGIN",
                    onPressed: (){
                          context.read<AppData>().setLoggedIn(true);
                    },
                    color: Colors.indigo,

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


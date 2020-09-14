import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/widgets/RoundedButton.dart';
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
                RoundedTextField(hintText:"Username",topMargin: userNameTop),
                RoundedTextField(hintText:"Password",topMargin: 5,isObscure: true,obscuringChar: '*',),
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

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    Key key,
    this.hintText,
    this.isObscure,
    this.obscuringChar,
    @required this.topMargin,
  }) : super(key: key);

  final bool isObscure;
  final String obscuringChar;
  final String hintText;
  final double topMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:topMargin,bottom: topMargin,left: 30,right: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border(
            top: BorderSide(color: Colors.white70,width: 1,style: BorderStyle.solid),
            right: BorderSide(color: Colors.white70,width: 1,style: BorderStyle.solid),
            bottom: BorderSide(color: Colors.white70,width: 1,style: BorderStyle.solid),
            left: BorderSide(color: Colors.white70,width: 1,style: BorderStyle.solid)
          ),

        ),
        child: TextField(
          obscureText: (isObscure!=null)?isObscure:false,
          obscuringCharacter: (obscuringChar!=null)?obscuringChar:' ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,

          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            alignLabelWithHint: true,

            hintStyle: TextStyle(color: Colors.white70,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20)

          ),
        ),
      )
    );
  }
}
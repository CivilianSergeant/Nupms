import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/LoginDataNotifier.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:nupms_app/model/ScheduleData.dart';
import 'package:nupms_app/screens/PaybackCollectionScreen.dart';
import 'package:nupms_app/screens/ScheduleScreen.dart';
import 'package:nupms_app/screens/UploadCollectionScreen.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget{
  String name;

  Sidebar({this.name});

  @override
  State<StatefulWidget> createState() => _SidebarState();

}

class _SidebarState extends State<Sidebar> {

  GlobalKey _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        key: _scaffoldKey,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.indigoAccent,//Color(0xff006777),
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: SizedBox(
                      width:100,
                      height:100,
                      child:  Material(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          color:Color(0xff3e9ede), //Color(0xff008e8e),
                          child: Icon(
                              Icons.account_circle,size: 75,
                              color:Colors.white
                          )),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Welcome ${widget.name!=null? widget.name :''}",style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left:40,top:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: SizedBox(

                          width: 230,
                          child: Row(
                            children: <Widget>[
                              Text("Payback",style: TextStyle(
                                  color: Colors.blueGrey
                              ),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 230,
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.calendar_today, color:Colors.black54),
                              SizedBox(width: 10,),
                              Text("Schedule",style: TextStyle(color:Colors.black54),),
                            ],
                          ),
                          onPressed: (){
                            context.read<AppData>().changeTitle("Schedule");
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=> ScheduleScreen()
                            ));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 230,
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.monetization_on, color:Colors.black54),
                              SizedBox(width: 10,),
                              Text("Collection",style: TextStyle( color:Colors.black54),),
                            ],
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=> PaybackCollectionScreen()
                            ));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 230,
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.cloud_upload, color:Colors.black54),
                              SizedBox(width: 10,),
                              Text("Upload Collection",style: TextStyle( color:Colors.black54),),
                            ],
                          ),
                          onPressed: (){
                            context.read<AppData>().changeTitle("Upload Collection");
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=> UploadCollectionScreen()
                            ));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 230,
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.account_balance, color:Colors.black54),
                              SizedBox(width: 10,),
                              Text("Deposit",style: TextStyle( color:Colors.black54),),
                            ],
                          ),
                          onPressed: (){

                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      (!context.watch<AppData>().showDownloadMenu)? SizedBox.shrink():SizedBox(
                        height: 30,
                        width: 230,
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.cloud_download, color:Colors.black54),
                              SizedBox(width: 10,),
                              Text("Download Master",style: TextStyle( color:Colors.black54),),
                            ],
                          ),
                          onPressed: (){
                            context.read<ScheduleData>().setMemberData([]);
                            context.read<PaybackCollectionData>().setMemberData([]);
                            context.read<LoginDataNotifier>().setMemberLoaded(0);
                            context.read<AppData>().setDownloadMaster();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
    );
  }

}
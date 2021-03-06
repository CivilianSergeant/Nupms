import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/ScheduleData.dart';
import 'package:nupms_app/model/ScheduleData.dart';
import 'package:nupms_app/persistance/services/CollectionService.dart';
import 'package:nupms_app/persistance/services/MemberService.dart';
import 'package:nupms_app/screens/DashboardScreen.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/ScheduleCard.dart';
import 'package:nupms_app/widgets/Sidebar.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_ScheduleScreenState();

}

class _ScheduleScreenState extends State<ScheduleScreen>{

  DateTime fromInitial;
  int fromStartYear;
  int fromEndYear;


  List<DropdownMenuItem<String>> codes = [];
  TextEditingController searchDate = TextEditingController();

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AppData>().changeTitle("NUMPS");
        return true;
      },
      child: Scaffold(
        appBar: TitleBar(
          elevation: 0,
          showSearch: true,
          icon: Icons.search,
          color: Colors.indigo,
          onPressed: (){
            showDialog(context: context,
                barrierDismissible: false,
                builder: (context){
                  return StatefulBuilder(
                    builder: (context,setState){
                      return Container(

                          margin: EdgeInsets.symmetric(horizontal:50,vertical: 150),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height:20,

                                margin:EdgeInsets.only(top:10,bottom: 20),
                                child: Text("Search Entrepreneur",

                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.indigo,
                                      decoration: TextDecoration.none
                                  ),),
                              ),
                              Divider(),
                              SizedBox(height: 20,),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.centerLeft,
                                child: Text("ENT. CODE", style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.none,
                                    color: Colors.black54
                                ),),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Material(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    items: codes,
                                    hint: Text("Select Code"),
                                    value: context.watch<ScheduleData>().selectedCode,
                                    onChanged: (value){
                                      context.read<ScheduleData>().selectedCode = value;
                                      setState((){});
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FlatButton(
                                    color: Colors.indigoAccent,
                                    textColor: Colors.white70,
                                    child: Text("Search"),
                                    onPressed: (){
                                      _refreshIndicatorKey.currentState?.show();
//                                        context.read<ScheduleData>().setSelectedCode(null);
                                    },
                                  ),
                                  FlatButton(
                                    color: Colors.deepOrangeAccent,
                                    textColor: Colors.white70,
                                    child: Text("Clear"),
                                    onPressed: (){
                                      context.read<ScheduleData>().setSelectedCode(null);
                                      _refreshIndicatorKey.currentState?.show();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              )

                            ],
                          ),
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          )
                      );
                    },
                  );
                }

            );
          },
        ).build(context),
//        drawer: Sidebar(),
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async{
              await loadMembers(code: context.read<ScheduleData>().selectedCode);
              return true;
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-60,

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:18.0,bottom: 5),
                    child: Text("${getDate()}", style: TextStyle(
                      color: Colors.white70,
                      fontSize: 25,
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:18.0,bottom: 10),
                    child: Text("Selected Code: ${context.watch<ScheduleData>().selectedCode !=null ? context.watch<ScheduleData>().selectedCode: 'None'}", style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: context.watch<ScheduleData>().Members.length,
                        itemBuilder: (context,i){
                          Map<String,dynamic> member  = context.watch<ScheduleData>().Members[i];
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: CardView(
                          member:MemberData(
                              businessName: member['business_name'],
                              code: member['entrepreneur_code'],

                          ),
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                          ),
                          card:ScheduleCard(memberData:MemberData(
                              businessName: member['business_name'],
                              code: member['entrepreneur_code'],
                              entrepreneurName: member['entrepreneur_name'],
                              totalInvestment: member['total_investment'],
                            unitName: context.watch<AppData>().user.unitName
                          )),
                          contentBackground: Colors.white,
                          background: Colors.indigoAccent,
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2),init);

  }

  void init(){
    context.read<ScheduleData>().setDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    fromInitial = DateTime.now();
    fromStartYear = fromInitial.year;
    fromEndYear = fromInitial.year+1;
    _refreshIndicatorKey.currentState?.show();
  }

  String getDate(){
    String _date = context.watch<ScheduleData>().selectedDate;
    if(_date != null){
      return DateFormat('dd MMMM, yyyy').format(DateTime.parse(_date));
    }
    return "";
  }

  loadMembers({String code}) async{
    if(code!=null){
      Navigator.of(context).pop();
    }
    List<Map<String,dynamic>> entrepreneurCodes = await CollectionService.getEntCodes();
    List<DropdownMenuItem<String>> _codes = [];
    entrepreneurCodes.forEach((element) {
      _codes.add(DropdownMenuItem(
        child: Text("${element['entrepreneur_code']}"),
        value: element['entrepreneur_code'],
      ));
    });

    if(mounted){
      setState(() {
        codes = _codes;
      });
    }

    List<Map<String,dynamic>> memberData = await MemberService.getMembers(code: code);
    context.read<ScheduleData>().setMemberData(memberData);
  }
}
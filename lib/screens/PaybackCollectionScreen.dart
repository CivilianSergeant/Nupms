import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:nupms_app/persistance/entity/Member.dart';
import 'package:nupms_app/persistance/services/CollectionService.dart';
import 'package:nupms_app/persistance/services/CompanyBankAccountService.dart';
import 'package:nupms_app/persistance/services/DepositModeService.dart';
import 'package:nupms_app/widgets/Collection.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:provider/provider.dart';

class PaybackCollectionScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _PaybackCollectionScreenState();
  
}

class _PaybackCollectionScreenState extends State<PaybackCollectionScreen>{

  List<Member> members = [];
  List<DropdownMenuItem<String>> codes = [];
  String selectedCode;

  List<Map<String,dynamic>> types =[];
  String _title = "Payback Collection";
  TextEditingController searchDate = TextEditingController();

  DateTime fromInitial;
  int fromStartYear;
  int fromEndYear;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{

        if(context.read<AppData>().isProcessing == true){
          return false;
        }

        context.read<AppData>().changeTitle("NUPMS");

        return true;
      },
      child: Scaffold(
          appBar: TitleBar(elevation: 0,showSearch: true,
                icon:Icons.search,
                onPressed: () {
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
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20,),
                                      alignment: Alignment.centerLeft,
                                      child: Text("PAYBACK DATE", style: TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.w900,
                                          decoration: TextDecoration.none,
                                          color: Colors.black54
                                      ),),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20,right:20,top:0,bottom: 20),
                                      child: Material(
                                        child: TextField(
                                          readOnly: true,
                                          controller: searchDate,
                                          onTap: (){
                                            showDatePicker(context: context, initialDate:fromInitial , firstDate: DateTime(fromStartYear), lastDate: DateTime(fromEndYear))
                                                .then((date){
                                              if(date != null){
                                                searchDate.text = (date.toString().substring(0,11).trim());
                                                context.read<PaybackCollectionData>().setDate(searchDate.text);
                                                fromInitial = DateTime.parse(searchDate.text);
                                                //                             getAgeInWords();
                                              }else{
                                                searchDate.text="";
                                                context.read<PaybackCollectionData>().setDate(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                                              }
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Select Date"
                                          ),
                                        ),
                                      ),
                                    ),
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
                                          value: context.watch<PaybackCollectionData>().selectedCode,
                                          onChanged: (value){
                                            context.read<PaybackCollectionData>().selectedCode = value;
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
//                                        context.read<PaybackCollectionData>().setSelectedCode(null);
                                          },
                                        ),
                                        FlatButton(
                                          color: Colors.deepOrangeAccent,
                                          textColor: Colors.white70,
                                          child: Text("Clear"),
                                          onPressed: (){
                                            context.read<PaybackCollectionData>().setSelectedCode(null);
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
                }).build(context),

          backgroundColor: Colors.indigo,
          body: SafeArea(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async{
                await loadMembers(code: context.read<PaybackCollectionData>().selectedCode);
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
                          child: Text("Selected Code: ${context.watch<PaybackCollectionData>().selectedCode !=null ? context.watch<PaybackCollectionData>().selectedCode: 'None'}", style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),),
                        ),
                        Expanded(child: Collection()),
                      ],
                  )
              )

            ),
          ),
      ),
    );
  }


  String getInstallmentNo(Payback payback){
    return (payback.installmentNo<10)? "0${payback.installmentNo}": "${payback.installmentNo}";
  }

  String getDate(){
    String _date = context.watch<PaybackCollectionData>().selectedDate;
    if(_date != null){
      return DateFormat('dd MMMM, yyyy').format(DateTime.parse(_date));
    }
    return "";
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2),init);
  }

  void init(){
    context.read<PaybackCollectionData>().setDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    fromInitial = DateTime.now();
    fromStartYear = fromInitial.year;
    fromEndYear = fromInitial.year+1;
    _refreshIndicatorKey.currentState?.show();
  }

  loadMembers({String code}) async {
    if(code!=null){
      Navigator.of(context).pop();
    }

    List<Map<String,dynamic>> _types = [];
    _types.add({"id":1,"name":"Cash"});
    _types.add({"id":2,"name":"DD"});
    context.read<PaybackCollectionData>().setTypes(_types);
    context.read<AppData>().changeTitle(_title);
    context.read<AppData>().setProcessing(true);
    List<MemberData> memberData = await CollectionService.getCollection(code: code,
        date:context.read<PaybackCollectionData>().selectedDate);

    List<Map<String,dynamic>> depositModes = await DepositModeService.getModes();






    AppConfig.log(memberData.length);
    List<Map<String,dynamic>> entrepreneurCodes = await CollectionService.getEntCodes();

    List<DropdownMenuItem<String>> _codes = [];
    entrepreneurCodes.forEach((element) {
      _codes.add(DropdownMenuItem(
        child: Text("${element['entrepreneur_code']}"),
        value: element['entrepreneur_code'],
      ));
    });

    context.read<AppData>().setProcessing(false);

    if(mounted){
      setState(() {
        codes = _codes;
      });
    }

     context.read<PaybackCollectionData>().setMemberData(memberData);
     context.read<PaybackCollectionData>().setDepositModes(depositModes);



  }


}
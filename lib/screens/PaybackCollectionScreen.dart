import 'package:flutter/material.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/Payback.dart';
import 'package:nupms_app/model/PaybackCollectionData.dart';
import 'package:nupms_app/persistance/entity/Member.dart';
import 'package:nupms_app/widgets/Collection.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:provider/provider.dart';

class PaybackCollectionScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _PaybackCollectionScreenState();
  
}

class _PaybackCollectionScreenState extends State<PaybackCollectionScreen>{

  List<Member> members = [];

  List<Map<String,dynamic>> types =[];
  String _title = "Payback Collection";

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.read<AppData>().changeTitle("NUMPS");
        print("here");
        return true;
      },
      child: Scaffold(
          appBar: TitleBar(elevation: 0,).build(context),
          backgroundColor: Colors.indigo,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height-80,
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () async{
                      loadMembers();
                      return true;
                    },
                    child: Collection()

                  )
              ),
            ),
          ),
      ),
    );
  }


  String getInstallmentNo(Payback payback){
    return (payback.installmentNo<10)? "0${payback.installmentNo}": "${payback.installmentNo}";
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2),loadMembers);
  }

  loadMembers() async {
    _refreshIndicatorKey.currentState?.show();
    context.read<AppData>().changeTitle(_title);
    await context.read<PaybackCollectionData>().loadMembers();
  }


}
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/model/ServiceResponse.dart';
import 'package:nupms_app/model/UploadCollectionData.dart';
import 'package:nupms_app/model/UploadCollectionData.dart';
import 'package:nupms_app/persistance/entity/User.dart';
import 'package:nupms_app/persistance/services/CollectionService.dart';
import 'package:nupms_app/persistance/services/DepositService.dart';
import 'package:nupms_app/persistance/services/MemberService.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/ScheduleCard.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:nupms_app/widgets/ToastMessage.dart';
import 'package:nupms_app/widgets/UploadCollectionCard.dart';
import 'package:provider/provider.dart';

class UploadCollectionScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_UploadCollectionScreenState();

}

class _UploadCollectionScreenState extends State<UploadCollectionScreen>{

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
        context.read<AppData>().changeTitle("NUPMS");
        return true;
      },
      child: Scaffold(
        appBar: TitleBar(
          elevation: 0,
          showSearch: false,
          icon: Icons.search,
          color: Colors.indigo,
          onPressed: (){
//            showDialog(context: context,
//                barrierDismissible: false,
//                builder: (context){
//                  return StatefulBuilder(
//                    builder: (context,setState){
//                      return Container(
//
//                          margin: EdgeInsets.symmetric(horizontal:50,vertical: 150),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: [
//                              Container(
//                                height:20,
//
//                                margin:EdgeInsets.only(top:10,bottom: 20),
//                                child: Text("Search Entrepreneur",
//
//                                  style: TextStyle(
//                                      fontSize: 15,
//                                      color: Colors.indigo,
//                                      decoration: TextDecoration.none
//                                  ),),
//                              ),
//                              Divider(),
//                              SizedBox(height: 20,),
//                              Container(
//                                margin: EdgeInsets.symmetric(horizontal: 20),
//                                alignment: Alignment.centerLeft,
//                                child: Text("ENT. CODE", style: TextStyle(
//                                    fontSize: 12, fontWeight: FontWeight.w900,
//                                    decoration: TextDecoration.none,
//                                    color: Colors.black54
//                                ),),
//                              ),
//                              Container(
//                                margin: EdgeInsets.symmetric(horizontal: 20),
//                                child: Material(
//                                  child: DropdownButton(
//                                    isExpanded: true,
//                                    items: codes,
//                                    hint: Text("Select Code"),
//                                    value: context.watch<UploadCollectionData>().selectedCode,
//                                    onChanged: (value){
//                                      context.read<UploadCollectionData>().selectedCode = value;
//                                      setState((){});
//                                    },
//                                  ),
//                                ),
//                              ),
//                              Row(
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                children: [
//                                  FlatButton(
//                                    color: Colors.indigoAccent,
//                                    textColor: Colors.white70,
//                                    child: Text("Search"),
//                                    onPressed: (){
//                                      _refreshIndicatorKey.currentState?.show();
////                                        context.read<UploadCollectionData>().setSelectedCode(null);
//                                    },
//                                  ),
//                                  FlatButton(
//                                    color: Colors.deepOrangeAccent,
//                                    textColor: Colors.white70,
//                                    child: Text("Clear"),
//                                    onPressed: (){
//                                      context.read<UploadCollectionData>().setSelectedCode(null);
//                                      _refreshIndicatorKey.currentState?.show();
//                                      Navigator.of(context).pop();
//                                    },
//                                  )
//                                ],
//                              )
//                            ],
//                          ),
//                          decoration:BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            color: Colors.white,
//                          )
//                      );
//                    },
//                  );
//                }
//            );
          },
        ).build(context),
//        drawer: Sidebar(),
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async{
              await loadMembers(code: null);
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
                    child: Text("${getDate(format: 1)}", style: TextStyle(
                      color: Colors.white70,
                      fontSize: 25,
                    ),),
                  ),
                  
                  Expanded(
                    child: ListView.builder(
                        itemCount: context.watch<UploadCollectionData>().Members.length,
                        itemBuilder: (context,i){
                          Map<String,dynamic> member  = context.watch<UploadCollectionData>().Members[i];
                          AppConfig.log(member);
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
                          card:UploadCollectionCard(memberData:MemberData(
                              businessName: member['business_name'],
                              code: member['entrepreneur_code'],
                              entrepreneurName: member['entrepreneur_name'],
                              totalInvestment: member['collected_amount'],
                              installmentNo: member['installment_no'],
                              collectionDate: member['collection_date'],
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.cloud_upload),
          backgroundColor: Colors.indigoAccent,
          onPressed: () async{

            User user = context.read<AppData>().user;
            List<Map<String,dynamic>> deposits = await DepositService.getDeposits();
            List<Map<String,dynamic>> _deposits = [];
            for(Map<String,dynamic> element in deposits) {
              var id = element['id'];
              File imgFile = (element['deposit_slip_image'] != null)? File(element['deposit_slip_image']) :null;
              Uint8List imageBytes;
              if(imgFile != null && imgFile.existsSync()) {
                imageBytes = imgFile.readAsBytesSync();
              }
              _deposits.add({
                'upToDate': getDate(date:element['up_to_date'],format: 2),
                'depositModeNo':element['deposit_slip_number'],
                'collectionTransferDateSt':getDate(date:element['collection_transfer_date'],format: 2),
                'depositModeId':element['deposit_mode_id'],
                'depositBankId':element['deposit_bank_id'],
                'depositBankBranchId':element['deposit_bank_branch_id'],
                'depositCompanyBankId':element['company_bank_account_id'],
                'depositTotalAmount':element['deposit_amount'],
                'depositSlipPic': (imageBytes!=null)?base64Encode(imageBytes):null,
                'details':await CollectionService.getDepositDetails(id)
              });
            }
            List<Map<String,dynamic>> _collections = context.read<UploadCollectionData>().Members.map((e) => {

              'paybackId': e['payback_id'],
              'newBusinessProposalId': e['new_business_proposal_id'],
              'collectionReceiptNo':e['receipt_no'],
              'collectionModeId':e['deposit_mode_id'],
              'collectionDt': getDate(date:e['collection_date'],format:2),
              'collectionModeNo':e['dd_cheque'],
              'collectionAmt':e['collected_amount'],
              'receivedRemarks':e['remark'],
              'bankingType':e['banking_type'],
              'depositBankId':e['company_account_id']

            }).toList();


            Map<String,dynamic> uploadData = {
              'orgShortCode':user.orgShortCode,
              'unitId': user.unitId,
              'employeeId': user.employeeId,
              'collections': _collections,
              'deposits': _deposits
            };
            ServiceResponse response = await CollectionService().uploadCollection(uploadData);
            AppConfig.log(uploadData);
            if(response.status == 200){
              await CollectionService.updateUploadedCollection();
              await loadMembers(code: null);
              ToastMessage.showMesssage(status: response.status,message: 'Collection Successfully uploaded',context: context);
              context.read<AppData>().showDownLoadMenu(true);
            }else{
              ToastMessage.showMesssage(status: response.status,message: response.message ,context: context);
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2),init);

  }



  void init(){
    context.read<UploadCollectionData>().setDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    fromInitial = DateTime.now();
    fromStartYear = fromInitial.year;
    fromEndYear = fromInitial.year+1;
    _refreshIndicatorKey.currentState?.show();
  }

  String getDate({String date,int format}){
    String _date = (date!=null)? date: context.watch<UploadCollectionData>().selectedDate;
    if(_date != null){
      String _format = (format==1)? 'dd MMMM, yyyy' : 'yyyy-MM-ddTHH:mm:ss';
      return DateFormat(_format).format(DateTime.parse(_date));
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

    List<Map<String,dynamic>> memberData = await CollectionService.getUploadedCollections();
    AppConfig.log(memberData);

    context.read<UploadCollectionData>().setMemberData(memberData);
  }
}
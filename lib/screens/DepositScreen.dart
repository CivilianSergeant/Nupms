import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/AppData.dart';
import 'package:nupms_app/model/DepositData.dart';
import 'package:nupms_app/model/MemberData.dart';
import 'package:nupms_app/persistance/entity/Deposit.dart';
import 'package:nupms_app/persistance/services/CollectionService.dart';
import 'package:nupms_app/persistance/services/CompanyBankAccountService.dart';
import 'package:nupms_app/persistance/services/DepositBankService.dart';
import 'package:nupms_app/persistance/services/DepositBranchService.dart';
import 'package:nupms_app/persistance/services/DepositModeService.dart';
import 'package:nupms_app/persistance/services/DepositService.dart';
import 'package:nupms_app/screens/camera_screen.dart';
import 'package:nupms_app/widgets/CardView.dart';
import 'package:nupms_app/widgets/DepositCard.dart';
import 'package:nupms_app/widgets/RoundedButton.dart';
import 'package:nupms_app/widgets/ScheduleCard.dart';
import 'package:nupms_app/widgets/TitleBar.dart';
import 'package:nupms_app/widgets/ToastMessage.dart';
import 'package:nupms_app/widgets/UploadCollectionCard.dart';
import 'package:provider/provider.dart';

class DepositScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen>{

  TextEditingController collectionTransferDate = TextEditingController();
  TextEditingController depositSlipSl = TextEditingController();
  TextEditingController depositSlipNo = TextEditingController();
  TextEditingController depositSendingType = TextEditingController();
  TextEditingController depositAmount = TextEditingController();


  DateTime fromInitial;
  int fromStartYear, fromEndYear;
  int selectedMode;
  int companyBankAccountId;
  int depositBankId;
  int depositBankBranchId;

  bool showCompanyAccount=false;

  bool showDepositList = true;

  bool showCollectionList=false;



  @override
  void initState() {
    fromInitial = DateTime.now();

    fromStartYear = fromInitial.year;
    fromEndYear = fromInitial.year+1;
    Future.delayed(Duration(milliseconds: 5),init);
  }

  Future<void> init() async{
    context.read<DepositData>().setDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    List<Map<String,dynamic>> depositModes = await DepositModeService.getModes();
    List<Map<String,dynamic>> depositBanks = await DepositBankService.getBanks();
    List<Map<String,dynamic>> _depositModes =[];
    depositModes.forEach((e) {
      if(e['deposit_mode_type']=='BOTH' || e['deposit_mode_type']=='DEP'){
        AppConfig.log(e);
        _depositModes.add(e);
      }
    });
    loadDepositables();
    setState(() {
      showDepositList=true;
    });
    context.read<DepositData>().setDepositModes(_depositModes);
    context.read<DepositData>().setDepositBanks(depositBanks);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(showCollectionList){
          setState(() {
            showCollectionList=false;
          });
          return false;
        }

        if(!showDepositList){
          setState(() {
            showCollectionList=false;
            showDepositList=true;
          });
          context.read<DepositData>().setSlipImagePath(null);
          return false;
        }

        context.read<AppData>().changeTitle("Nupms");
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.indigo,
        appBar: TitleBar(color: Colors.indigo, elevation: 0,).build(context),
        body: SingleChildScrollView(
          child: (showDepositList)? depositList(context) : (showCollectionList)? collectionList(context): form(context),
        ),
        floatingActionButton: (!showDepositList)? SizedBox.shrink(): FloatingActionButton(
          onPressed: (){
            setState(() {
              showDepositList=false;
            });
          },
          backgroundColor: Colors.indigoAccent,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget depositList(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: context.watch<DepositData>().Deposits.length,
          itemBuilder: (context,i){
            Map<String,dynamic> deposit = context.read<DepositData>().Deposits[i];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CardView(
                text: getDate(date:deposit['collection_transfer_date']),
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                ),
                card:DepositCard(
                  img : deposit['deposit_slip_image'],
                  memberData: MemberData(
                    totalInvestment: deposit['deposit_amount'],

                  ),
                ),
                contentBackground: Colors.white,
                background: Colors.indigoAccent,
              ),
            );
          }
      ),
    );
  }

  Widget collectionList(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height-150,
          color:Colors.white,
          child:ListView.builder(
              itemCount: context.watch<DepositData>().Depositables.length,
              itemBuilder: (context,i){
                Map<String,dynamic> depositable = context.watch<DepositData>().Depositables[i];
                AppConfig.log(depositable);
                return Container(
                  padding: EdgeInsets.only(bottom:10),
                  decoration: BoxDecoration(
                    color: Colors.white,

                    border:Border(
                      bottom: BorderSide(width: 1, color:Colors.grey,style: BorderStyle.solid),

                    )
                  ),
                  child: CheckboxListTile(

                    checkColor: Colors.white,
                    activeColor: Colors.indigoAccent,
                    onChanged: (value){
                      depositable['selected']=value;
                      context.read<DepositData>().updateUI();
                    },
                    value:depositable['selected'],
                    title: Text("${depositable['business_name']}",style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700,
                      color: Colors.indigoAccent
                    ),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${depositable['entrepreneur_name']}",style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700
                        ),),
                        SizedBox(height: 10,),
                        Text("Installment No: ${depositable['installment_no']}",style:TextStyle(
                          fontSize: 16,
                        )),
                        Text("${depositable['collected_amount']}",style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700
                        ),),
                        Text("${getDate(date:depositable['collection_date'])}")
                      ],
                    ),
                  ),
                );
              }
          )
        ),
        RoundedButton(
          text: "Select Deposit Amount",
          color: Colors.indigoAccent,
          onPressed: (){
             double _depositAmount = 0;
             context.read<DepositData>().Depositables.forEach((element) {
               if(element['selected']){
                 _depositAmount+= element['collected_amount'];
               }
             });
             AppConfig.log(_depositAmount);
             context.read<DepositData>().setDepositAmount(_depositAmount);
             setState(() {
               depositAmount.text = _depositAmount.toString();
               showCollectionList=false;
             });
          },
        )
      ],
    );
  }

  Widget form(BuildContext context) {
    return Container(
          child: Column(
            children:<Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:18.0,bottom: 5),
                  child: Text("${getDate()}", style: TextStyle(
                    color: Colors.white70,
                    fontSize: 25,
                  ),),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:2.0,right:10,left:20),
                  child: Text("UP TO DATE", style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      color: Colors.white70
                  ),),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right:10.0),
                  child: Text("${context.watch<DepositData>().CollectionAmount} BDT",
                    textAlign: TextAlign.right,
                    style: TextStyle(

                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        color: Colors.white70
                    ),),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top:2.0,right:10),
                  child: Text("COLLECTION AMOUNT", style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      color: Colors.white70
                  ),),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-260,
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: SingleChildScrollView(
                  child: Column(

                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Container(
                            width: MediaQuery.of(context).size.width-80,
                            child: TextField(

                              readOnly: true,
                              controller: collectionTransferDate,
                              onTap: (){
                                showDatePicker(context: context, initialDate:fromInitial , firstDate: DateTime(fromStartYear), lastDate: DateTime(fromEndYear))
                                    .then((date){
                                  if(date != null){
                                    collectionTransferDate.text = (date.toString().substring(0,11).trim());
                                    fromInitial = DateTime.parse(collectionTransferDate.text);
                                    //                             getAgeInWords();
                                  }else{
                                    collectionTransferDate.text="";
                                  }
                                });
                              },
                              style: TextStyle(
                                  fontSize: 14,

                                  color: Colors.black54
                              ),
                              decoration:InputDecoration(hintText: "Collection Transfer Date",

                                  hintStyle: TextStyle(
                                      color:Colors.black54
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 120,
                            child: TextField(
                              controller: depositSlipNo,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Colors.black54
                                  ),
                                  hintText: "Deposit Slip No"
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 58,
                            child: DropdownButton(
                              value: selectedMode,
                              items: context.watch<DepositData>().DepositTypes.map((e) => DropdownMenuItem(
                                value: e['deposit_mode_id'],
                                child: Text(e['deposit_mode_name'],style: TextStyle(color:Colors.black54),),
                              ))
                                  .toList(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              hint: Text('Deposit Type',style: TextStyle(
                                  color: Colors.black54
                              ),),
                              onChanged: (value) async{
                                showCompanyAccount=false;
                                setState(() {
                                  selectedMode = value;
                                  depositBankId=null;
                                  depositBankBranchId=null;
                                  companyBankAccountId=null;
                                });
                                List<Map<String,
                                    dynamic>> companyBankAccounts = await CompanyBankAccountService
                                    .getCompanyBankAccounts(value);

                                context.read<DepositData>().setCompanyAccounts(companyBankAccounts);

                                context.read<DepositData>().DepositTypes.forEach((element) async {
                                  AppConfig.log(element['deposit_mode_name'].toString().toLowerCase());
                                  if(element['deposit_mode_id'] == value && element['deposit_mode_name'].toString().toLowerCase() == 'dd') {

                                    setState(() {
                                      showCompanyAccount = true;
                                    });


                                  }

                                });
//                                  AppConfig.log(showCompanyAccount);
                              },
                            ),
                          ),
                        ],
                      ),
                      (!showCompanyAccount)? SizedBox.shrink():Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width-85,
                            margin: EdgeInsets.only(top:10,left: 10,right: 15),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Colors.grey,
                                        style: BorderStyle.solid))),
                            child: DropdownButton(
                              isExpanded: true,
                              style: TextStyle( fontSize: 14, color: Colors.black),
                              value: depositBankId,
                              onChanged: (value) async{
                                setState(() {
                                  depositBankId = value;
                                  depositBankBranchId=null;
                                });

                                List<Map<String,dynamic>> _depositBankBranches = await DepositBranchService.getBranches(value);
                                context.read<DepositData>().setDepositBankBranches(_depositBankBranches);
                              },
                              items: context
                                  .watch<DepositData>()
                                  .DepositBanks
                                  .map((e) => DropdownMenuItem(
                                value: e['deposit_bank_id'],
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text("${e['deposit_bank_name']}"),
                                ),
                              ))
                                  .toList(),
                              hint: Text("Deposit Bank"),
                              underline: SizedBox.shrink(),
                            ),
                          )
                        ],
                      ),
                      (!showCompanyAccount)? SizedBox.shrink(): Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width-85,
                            margin: EdgeInsets.only(top:10,left: 10,right: 15),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Colors.grey,
                                        style: BorderStyle.solid))),
                            child: DropdownButton(
                              isExpanded: true,
                              style: TextStyle( fontSize: 14, color: Colors.black),
                              value: depositBankBranchId,
                              onChanged: (value) async{
                                setState(() {
                                  depositBankBranchId = value;
                                });


                              },
                              items: context
                                  .watch<DepositData>()
                                  .DepositBankBranches
                                  .map((e) => DropdownMenuItem(
                                value: e['deposit_bank_branch_id'],
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text("${e['deposit_bank_branch_name']}"),
                                ),
                              ))
                                  .toList(),
                              hint: Text("Deposit Bank Branch"),
                              underline: SizedBox.shrink(),
                            ),
                          )
                        ],
                      ),
                      (!showCompanyAccount)? SizedBox.shrink(): Container(
                        width: MediaQuery.of(context).size.width-80,
                        child: TextField(
                          controller: depositSendingType,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: Colors.black54
                              ),
                              hintText: "Deposit Sending Type"
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width-85,
                            margin: EdgeInsets.only(top:10,left: 10,right: 15),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Colors.grey,
                                        style: BorderStyle.solid))),
                            child: DropdownButton(
                              isExpanded: true,
                              style: TextStyle( fontSize: 14, color: Colors.black),
                              value: companyBankAccountId,
                              onChanged: (value) {
                                companyBankAccountId = value;
                                context.read<DepositData>().updateUI();
                              },
                              items: context
                                  .watch<DepositData>()
                                  .CompanyBankAccounts
                                  .map((e) => DropdownMenuItem(
                                value: e['company_bank_id'],
                                child: Container(

                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Text("${e['company_bank_name']},${e['company_bank_branch_name']}",style: TextStyle(
                                          fontSize: 12
                                        ),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Text("${e['account_name']} - [${e['account_no']}]",style: TextStyle(
                                            fontSize: 12
                                        ),),
                                      ),
                                      Divider()
                                    ],
                                  ),
                                ),
                              ))
                                  .toList(),
                              hint: Text("Company Bank Accounts"),
                              underline: SizedBox.shrink(),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width-80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: TextField(
                                controller: depositAmount,
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        color: Colors.black54
                                    ),
                                    hintText: "Deposit Amount"
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_box, color: Colors.indigoAccent,),
                              onPressed: () async {
                                setState(() {
                                  showCollectionList = true;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (context.watch<DepositData>().slipImgPath !=null)? Image.asset(context.watch<DepositData>().slipImgPath,width: 100,) :Text("Slip Image"),
                          IconButton(
                            onPressed: () async{
                                 Navigator.of(context).push(MaterialPageRoute(
                                   builder: (context)=> CameraScreen()
                                 ));
                            },
                            icon: Icon(Icons.camera_alt,color: Colors.indigoAccent,),
                          )
                        ],
                      )

                    ],
                  ),
                ),
              ),
              RoundedButton(
                text: "Deposit",
                color: Colors.indigoAccent,
                onPressed: () async {
                   if(!validate(context)){
                     return;
                   }

                   int inserted = await DepositService.saveDeposit(Deposit(
                     depositBankId: depositBankId,
                     depositModeId: selectedMode,
                     depositBankBranchId: depositBankBranchId,
                     collectionTransferDate: collectionTransferDate.text,
                     depositAmount: double.parse(depositAmount.text),
                     companyBankAccountId: companyBankAccountId,
                     depositSendingType: depositSendingType.text,
                     depositSlipNumber: depositSlipNo.text,
                     depositSlipImage: context.read<DepositData>().slipImgPath,
                     upToDate: context.read<DepositData>().selectedDate
                   ));

                   if(inserted>0){
                     context.read<DepositData>().Depositables.forEach((element) async {
                       if(element['selected']){
                         await CollectionService.updateDeposit(element['id'],inserted);
                       }
                     });
                     ToastMessage.showMesssage(status:200,message:'Deposit Done',context: context);
                     loadDepositables();
                     clearForm();
                   }
                },
              )
            ]
          ),
        );
  }

  bool validate(BuildContext context){
    if(collectionTransferDate.text.length==0){
      ToastMessage.showMesssage(status: 500,message: 'Please Select Collection Transfer Date',context: context);
      return false;
    }
    if(selectedMode==null ||  selectedMode==0){
      ToastMessage.showMesssage(status: 500,message: 'Please Select Deposit Type', context: context);
      return false;
    }

    if(showCompanyAccount){
      if(depositBankId==null || depositBankId==0){
        ToastMessage.showMesssage(status: 500,message: 'Please Select Deposit Bank', context: context);
        return false;
      }

      if(depositBankBranchId == null || depositBankBranchId == 0){
        ToastMessage.showMesssage(status: 500,message: 'Please Select Deposit Bank Branch', context: context);
        return false;
      }
    }

    if(companyBankAccountId==null || companyBankAccountId==0){
      ToastMessage.showMesssage(status: 500,message: 'Please Select Company Bank Account', context: context);
      return false;
    }

    if(depositAmount.text.length==0){
      ToastMessage.showMesssage(status: 500,message: 'Please Select Collection', context: context);
      return false;
    }
    double _depositAmount = double.parse(depositAmount.text);
    if(_depositAmount==0){
      ToastMessage.showMesssage(status: 500,message: 'Please Select Collection', context: context);
      return false;
    }
    return true;

  }

  void clearForm(){
    companyBankAccountId=null;
    depositSlipNo.text='';
    depositAmount.text='';
    depositBankId=null;
    depositBankBranchId=null;
    selectedMode=null;
    depositSendingType.text='';
    context.read<DepositData>().setSlipImagePath(null);
  }
  Future<void> loadDepositables() async {
    String date = context.read<DepositData>().getDate();
    List<Map<String,dynamic>> deposits = await DepositService.getDeposits();

    AppConfig.log(deposits);
    List<Map<String,dynamic>> depositables = await DepositService.getDepositables(date);
    double collectionAmount =0;
    context.read<DepositData>().setDepositables(depositables);
    context.read<DepositData>().setDeposits(deposits);

    AppConfig.log(depositables);
  }

  String getDate({String date}){
    String _date = (date!=null)? date : context.watch<DepositData>().selectedDate;
    AppConfig.log(_date,line:'478');
    if(_date != null && _date.trim().length>5){
      return DateFormat('dd MMMM, yyyy').format(DateTime.parse(_date));
    }
    return "";
  }


  
}
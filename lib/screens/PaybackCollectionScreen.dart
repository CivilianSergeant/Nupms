import 'package:flutter/material.dart';
import 'package:nupms_app/entity/Member.dart';
import 'package:nupms_app/entity/Payback.dart';

class PaybackCollectionScreen extends StatefulWidget{

  String title;

  PaybackCollectionScreen({this.title});

  @override
  State<StatefulWidget> createState() => _PaybackCollectionScreenState();
  
}

class _PaybackCollectionScreenState extends State<PaybackCollectionScreen>{

  List<Member> members = [];
  PageController _pageController = PageController();
  List<Map<String,dynamic>> types =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title,textAlign: TextAlign.center,)),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){

              },
            )
          ],
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                color: Color(0xffafafcf),
//            padding: EdgeInsets.only(top:10),
                height: MediaQuery.of(context).size.height-80,
                child: RefreshIndicator(
                  onRefresh: () async{
                    await loadMembers();
                    return true;
                  },
                  child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, i){
                        Member member = members[i];
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 298,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Color(0x2f000000),offset: Offset.fromDirection(1), blurRadius: 1,spreadRadius: 1)
                            ],
                            color: Colors.blueAccent,
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${member.businessName}",style:TextStyle(

                                        color: Colors.white70,
                                        fontWeight: FontWeight.w900
                                    ),),
                                    Text("Ent-Code: ${member.code}",style:TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w900
                                    ),),
                                  ],
                                ),
                              ),


                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 198,
                                color: Colors.white,

                                child: PageView.builder(
//                              controller: _scrollController2,
                                    controller:_pageController ,
                                    pageSnapping: true,
                                    onPageChanged: (value){
                                      setState(() {
                                        member.currentPageNo = value;
                                      });
                                    },
//                              physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: member.paybacks.length,
                                    itemBuilder: (context,j){
                                      Payback payback = member.paybacks[j];
                                      return Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 150,

                                        decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(width: 1,style: BorderStyle.solid,color: Color(0xffcccccc))
                                            )
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width:50,
                                                  padding:EdgeInsets.only(left:10,top:10),
                                                  child: CircleAvatar(

                                                    child: Text("${getInstallmentNo(payback)}",),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left:15,top:10),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Container(

                                                                  child: Text("${payback.remaining}",style: TextStyle(
                                                                      fontWeight: FontWeight.bold,color:Colors.redAccent,
                                                                      fontSize: 15
                                                                  ),)),
                                                              Container(
                                                                  decoration:BoxDecoration(
                                                                      border: Border(
                                                                          top:BorderSide(color: Colors.grey,width: 1,style:BorderStyle.solid)
                                                                      )
                                                                  ),
                                                                  child: Text("RECOVERABLE",style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w900,
                                                                      color:Colors.black54
                                                                  ),))
                                                            ],
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Column(
                                                            children: [
                                                              Container(

                                                                  child: Text("${payback.totalPayback}",style: TextStyle(
                                                                      fontWeight: FontWeight.bold,color:Colors.redAccent,
                                                                      fontSize: 15
                                                                  ),)),
                                                              Container(
                                                                decoration:BoxDecoration(
                                                                    border: Border(
                                                                        top:BorderSide(color: Colors.grey,width: 1,style:BorderStyle.solid)
                                                                    )
                                                                ),
                                                                child: Text("Total Payback"),)
                                                            ],
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Column(
                                                            children: [
                                                              Container(

                                                                  child: Text("${payback.collected}",style: TextStyle(
                                                                      fontWeight: FontWeight.bold,color:Colors.redAccent,
                                                                      fontSize: 15
                                                                  ),)),
                                                              Container(
                                                                decoration:BoxDecoration(
                                                                    border: Border(
                                                                        top:BorderSide(color: Colors.grey,width: 1,style:BorderStyle.solid)
                                                                    )
                                                                ),
                                                                child: Text("Collected"),)
                                                            ],
                                                          )

                                                        ],
                                                      ),
                                                    ),

                                                  ],
                                                ),


                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Container(
                                                    padding:EdgeInsets.only(top:10,left:10),
                                                    child: Text("Payback Date: ${payback.paybackDate}",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.blueAccent
                                                      ),)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Container(
                                                  width:100,
                                                  padding:EdgeInsets.only(top:0,left:10),
                                                  child: Column(
                                                    children: [

                                                      TextField(
                                                        style: TextStyle(
                                                          fontSize: 12,

                                                        ),
                                                        decoration: InputDecoration(

                                                            hintText: "Collection Date"
                                                        ),
                                                      )

                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  margin:EdgeInsets.only(left:10),
                                                  child: TextField(
                                                    style: TextStyle(
                                                        fontSize: 12
                                                    ),
                                                    decoration: InputDecoration(

                                                        hintText: "Receipt No"
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 106,
                                                  margin:EdgeInsets.only(left:10),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(width: 1,color:Colors.grey,style:BorderStyle.solid)
                                                      )
                                                  ),
                                                  child: DropdownButton(
                                                    style: TextStyle(
                                                        height: 2,
                                                        fontSize: 12,
                                                        color: Colors.black
                                                    ),
                                                    value: payback.selectedType,
                                                    onChanged: (value){
                                                      setState(() {
                                                        payback.selectedType = value;
                                                      });
                                                    },
                                                    items: types.map((e) => DropdownMenuItem(
                                                      value: e['id'],
                                                      child: Text(e['name']),
                                                    )).toList(),
                                                    hint: Text("Col. Type"),
                                                    underline: SizedBox.shrink(),
                                                  ),
                                                ),

                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Container(
                                                  width: 90,
                                                  margin:EdgeInsets.only(left:10),
                                                  child: TextField(
                                                    style: TextStyle(
                                                        fontSize: 12
                                                    ),
                                                    decoration: InputDecoration(

                                                        hintText: "DD / Cheque"
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  margin:EdgeInsets.only(left:10),
                                                  child: TextField(
                                                    style: TextStyle(
                                                        fontSize: 12
                                                    ),
                                                    decoration: InputDecoration(

                                                        hintText: "Amount"
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  margin:EdgeInsets.only(left:10),
                                                  child: TextField(
                                                    style: TextStyle(
                                                        fontSize: 12
                                                    ),
                                                    decoration: InputDecoration(

                                                        hintText: "Remark"
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            )


                                          ],
                                        ),

                                      );
                                    }),
                              ),
                              Container(
                                padding: EdgeInsets.only(left:10,right:(MediaQuery.of(context).size.width-150)),
                                color:Colors.white70,
                                width: MediaQuery.of(context).size.width,
                                child: FlatButton(

                                  color: Colors.indigoAccent,
                                  child: Text("COLLECT",style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),),

                                  onPressed: (){
//                                print(member.currentPageNo);
                                    double offset = (member.currentPageNo+1)*340.0;
                                    _pageController.animateTo(offset, duration: Duration(milliseconds:700), curve: Curves.easeIn);

                                    setState(() {

                                    });

                                  },
                                ),
                              )
                            ],
                          ),



                        );
                      }),
                )
            ),
          ),
        ),
    );
  }

  loadMembers(){
    List<Member> _members = [];
    List<Payback> _paybacks = [];


    _paybacks.add(Payback(
        installmentNo: 01,
        collected: 0,
        remaining: 2700,
        totalPayback: 2700,
        paybackDate: "03-Dec-2020"


    ));
    _paybacks.add(Payback(
        installmentNo: 02,
        collected: 0,
        remaining: 2700,
        totalPayback: 2700,
        paybackDate: "03-Jan-2021"

    ));
    _paybacks.add(Payback(
        installmentNo: 03,
        collected: 0,
        remaining: 2700,
        totalPayback: 2700,
        paybackDate: "03-Feb-2021"

    ));

    _members.add(Member(
        code: '13410230',
        businessName: 'Tama Cosmetics',
        paybacks: _paybacks
    ));

    _members.add(Member(
        code: '13410231',
        businessName: 'Rifat Telecom',
        paybacks: [
          Payback(
              installmentNo: 01,
              collected: 0,
              remaining: 2700,
              totalPayback: 2700,
              paybackDate: "03-Dec-2020"
          )
        ]
    ));


    setState(() {
      members = _members;
      types.add({"id":1,"name":"Cash"});
      types.add({"id":2,"name":"DD"});
    });

  }

  String getInstallmentNo(Payback payback){
    return (payback.installmentNo<10)? "0${payback.installmentNo}": "${payback.installmentNo}";
  }

  @override
  void initState() {
    loadMembers();
  }
  
  
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nupms_app/config/AppConfig.dart';
import 'package:nupms_app/model/MemberData.dart';


class UploadCollectionData with ChangeNotifier{

    List<Map<String,dynamic>> _members = [];
    String selectedCode;

    String selectedDate;


    List<Map<String,dynamic>> _types = [];

    List<Map<String,dynamic>> get Types{
        return this._types;
    }

    List<Map<String,dynamic>> get Members{
        return _members;
    }

    void updateUI(){
        notifyListeners();
    }

//    void updateMemberPayback(MemberData member, MemberData lastRecord){
//        if(lastRecord==null){
//            AppConfig.log("HERE LastRecord null");
//            return;
//        }
//       int index =  _members.indexOf(member);
//       _members[index]=lastRecord;
//       AppConfig.log('Index ${index}');
//       notifyListeners();
//    }

    void setTypes(List<Map<String,dynamic>> t){
        this._types = t;
        notifyListeners();
    }

    void setMemberData(List<Map<String,dynamic>> memberData){
        this._members = memberData;
        notifyListeners();
    }

    void setSelectedCode(String c){
        this.selectedCode = c;
        notifyListeners();
    }

    void setDate(String d){
        AppConfig.log(d);
        this.selectedDate = d;
        notifyListeners();
    }

    String getDate(){
        AppConfig.log(selectedDate);
        return DateFormat("dd MMMM, yyyy").format(DateTime.parse(selectedDate));
    }



    void updateCurrentPage(MemberData member, {int value}){

        member.currentPageNo = (value!=null)? value : (member.currentPageNo+1);
        notifyListeners();
    }


}
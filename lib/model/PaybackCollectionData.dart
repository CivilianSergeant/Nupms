import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nupms_app/entity/Member.dart';
import 'package:nupms_app/entity/Payback.dart';
import 'package:nupms_app/model/MemberData.dart';

class PaybackCollectionData with ChangeNotifier{

    List<MemberData> _members = [];
    List<Map<String,dynamic>> _types = [];

    List<Map<String,dynamic>> get Types{
        return this._types;
    }

    List<MemberData> get Members{
        return _members;
    }


    void updateCurrentPage(MemberData member, {int value}){

        member.currentPageNo = (value!=null)? value : (member.currentPageNo+1);
        notifyListeners();
    }

    void loadMembers() {
        List<MemberData> _members = [];
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

        _members.add(MemberData(
            pageController: PageController(),
            code: '13410230',
            businessName: 'Tama Cosmetics',
            paybacks: _paybacks
        ));

        _members.add(MemberData(
            pageController: PageController(),
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
        this._members = _members;
        this._types.add({"id":1,"name":"Cash"});
        this._types.add({"id":2,"name":"DD"});

        notifyListeners();
    }

}
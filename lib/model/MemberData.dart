import 'package:flutter/material.dart';
import 'package:nupms_app/model/Payback.dart';


class MemberData{
  PageController pageController;
  int currentPageNo;
  String code;
  String businessName;
  String unitName;
  String entrepreneurName;
  int slNo;
  double totalInvestment;
  List<Payback> paybacks;

  MemberData({
    this.pageController,
    this.slNo,
    this.currentPageNo,
    this.code,
    this.businessName,
    this.unitName,
    this.entrepreneurName,
    this.paybacks,
    this.totalInvestment
  });


}
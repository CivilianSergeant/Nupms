import 'package:flutter/material.dart';
import 'package:nupms_app/model/Payback.dart';


class MemberData{
  PageController pageController;
  int currentPageNo;
  String code;
  String businessName;
  String unitName;
  String entrepreneurName;
  String collectionDate;
  int slNo;
  int installmentNo;
  double totalInvestment;
  List<Payback> paybacks;

  MemberData({
    this.pageController,
    this.slNo,
    this.currentPageNo,
    this.code,
    this.businessName,
    this.collectionDate,
    this.unitName,
    this.entrepreneurName,
    this.paybacks,
    this.installmentNo,
    this.totalInvestment
  });


}
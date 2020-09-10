import 'package:flutter/material.dart';
import 'package:nupms_app/entity/Payback.dart';

class MemberData{
  PageController pageController;
  int currentPageNo;
  String code;
  String businessName;
  int slNo;
  List<Payback> paybacks;

  MemberData({
    this.pageController,
    this.slNo,
    this.currentPageNo,
    this.code,
    this.businessName,
    this.paybacks
  });
}
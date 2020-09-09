import 'package:nupms_app/entity/Payback.dart';

class Member{
  int currentPageNo;
  String code;
  String businessName;
  int slNo;
  List<Payback> paybacks;

  Member({
    this.slNo,
    this.currentPageNo,
    this.code,
    this.businessName,
    this.paybacks
  });
}
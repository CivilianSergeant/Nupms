import 'package:flutter/foundation.dart';

class LoginDataNotifier with ChangeNotifier{

    int memberCount=0;
    int memberLoaded=0;

    setMemberCount(int c){
      memberCount=c;
      notifyListeners();
    }

    setMemberLoaded(int l){
      memberLoaded = l;
      notifyListeners();
    }

    String getProgress(){
     return (memberLoaded>0 && memberCount>0)? ((memberLoaded/memberCount)*100).round().toString() + "%":  "0%" ;
    }



}
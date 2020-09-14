import 'package:flutter/foundation.dart';

class AppData with ChangeNotifier{
    String _title = "NUPMS";
    bool isLoggedIn = false;


    String get Title{
      return _title;
    }

    void setLoggedIn(bool status){
      this.isLoggedIn = status;
      notifyListeners();
    }

    void changeTitle(String title){
      _title = title;
      notifyListeners();
    }


}
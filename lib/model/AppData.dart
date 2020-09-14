import 'package:flutter/foundation.dart';

class AppData with ChangeNotifier{
    String _title = "NUPMS";
    bool isLoggedIn = false;
    bool isAppLoaded = false;

    String get Title{
      return _title;
    }

    void setAppLoaded(bool status){
      this.isAppLoaded = status;
      notifyListeners();
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
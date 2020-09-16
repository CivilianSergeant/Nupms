import 'package:flutter/foundation.dart';
import 'package:nupms_app/persistance/entity/User.dart';

class AppData with ChangeNotifier{
    String _title = "NUPMS";
    bool isLoggedIn = false;
    bool isProcessing = false;
    bool isAppLoaded = false;
    int totalEnts = 0;
    double totalCollectedAmount=0;

    User user = null;

    String get Title{
      return _title;
    }

    void setUser(User u){
      user = u;
      notifyListeners();
    }

    void setTotalEnts(int t){
      totalEnts = t;
      notifyListeners();
    }
    void setTotalCollectedAmount(double t){
      totalCollectedAmount = t;
      notifyListeners();
    }

    void setProcessing(bool status){
      this.isProcessing = status;
      notifyListeners();
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
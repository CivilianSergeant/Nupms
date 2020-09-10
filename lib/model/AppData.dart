import 'package:flutter/foundation.dart';

class AppData with ChangeNotifier{
    String _title = "NUPMS";


    String get Title{
      return _title;
    }

    void changeTitle(String title){
      _title = title;
      notifyListeners();
    }


}
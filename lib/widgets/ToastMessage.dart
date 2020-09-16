import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastMessage{
    int status;
    String message;
    BuildContext context;
    ToastMessage({this.status,this.message,this.context});

    static void showMesssage({int status,String message,BuildContext context}){
      Toast.show(message,context,duration: Toast.LENGTH_LONG,
      backgroundColor: (status==200)? Colors.green : Colors.red,
      textColor: Colors.white70,
      gravity: Toast.TOP);
    }

}
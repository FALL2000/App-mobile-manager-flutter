import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
    
class MAExitablePage extends StatelessWidget {
  final child;

   MAExitablePage({
    super.key,
    required this.child
  });
  var ctime;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(

            onWillPop: () {
                DateTime now = DateTime.now();
                
                if (ctime == null || now.difference(ctime) > Duration(seconds: 2)) { 
                    //add duration of press gap
                    ctime = now;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Press Back Button Again to Exit')) 
                    ); 
                    return Future.value(false);
                }
                SystemNavigator.pop();//work and recommended only for android
                return Future.value(false);
            },

            child:child
          );
  }
}

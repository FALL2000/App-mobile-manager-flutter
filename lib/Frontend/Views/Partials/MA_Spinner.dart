import 'package:flutter/material.dart';
    
class MaSpinner extends StatelessWidget {

  String title='';


   MaSpinner({ Key? key, String? title}) : super(key: key){
      this.title = title ?? 'Awaiting result...';
   }
  
  @override
  Widget build(BuildContext context) {
    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(title),
                ),
              ],
            ),
    );
  }
}
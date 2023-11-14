import 'package:flutter/material.dart';
    
import 'package:flutter_spinkit/flutter_spinkit.dart';
class MaSpinner extends StatefulWidget {

  String title='';


   MaSpinner({ Key? key, String? title}) : super(key: key){
      this.title = title ?? 'Awaiting result...';
   }

  @override
  State<MaSpinner> createState() => _MaSpinnerState();
}

class _MaSpinnerState extends State<MaSpinner> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   width: 60,
                //   height: 60,
                //   child: CircularProgressIndicator(),
                // ),
                 SpinKitChasingDots(
                    color: Theme.of(context).colorScheme.primary,
                    size: 100.0,
                    // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(widget.title, 
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                ),
              ],
            ),
    );
  }
}
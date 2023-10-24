import 'package:flutter/material.dart';
    
class MaHomePage extends StatelessWidget {

  const MaHomePage({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // appBar: AppBar(
      //   // title:  Text('Profile'),
      //   bottom:  PreferredSize(
      //         preferredSize: const Size.fromHeight(50),
      //         child: Card(),
      //   ),
      // ),
      body:   Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Container(
              // width: 300,
              height: 70,
              color: AppBarTheme.of(context).backgroundColor,
            ),
          ),
          
           Positioned( //<-- SEE HERE
            left: 0,
            top: 15,
            child:
            Column(
              children: [
               const  SizedBox(
                    width: 400,
                    height: 150,
                    // color: Colors.yellow,
                    child: Padding(
                      padding:  EdgeInsets.only(left: 20.0),
                      child: Card( elevation: 3,
                          child: ListTile(title: Text('Cloford'),
                          leading: Icon(Icons.abc_rounded),
                          )
                      ),
                    ),
                  ),
                  Container(
                  width: 700,
                  height: 70,
                  color: Colors.blue,
                ),
              ],
            ), 
            
            ) 
            
          
        ],
      ),
    );
  }
}
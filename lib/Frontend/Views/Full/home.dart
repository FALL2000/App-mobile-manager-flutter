
import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_loginController.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body:  Column(
        children: [Text(
          'home'
        ),
        ElevatedButton(onPressed: () async{

                await signOut();
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushNamed(context, '/login');
          }, child: Text('logout'))
        ]
      ),
    );
  }
}

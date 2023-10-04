import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:x_money_manager/model/MA_User.dart';
import 'package:x_money_manager/firebase_options.dart';
import 'package:x_money_manager/Notification/MA_firebaseNotification.dart';
class AuthController extends GetxController { 

bool _loggedIn = true;
  User? _user ;
  MaUser? storedUser ;
  User? get authUser=> _user ;
  bool get loggedIn => _loggedIn;
  Future<bool> _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    print('Welcome $_loggedIn');
    // await Future.delayed(const Duration(seconds: 5));
    await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform);
    await MaFirebaseNotification.init();
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        print('user is logged in ');
        _user= user;
        print(_user);
        _loggedIn = true;
        // MaFirebaseNotification.getDeviceToken();
      } else {
        print('user is logged out ');
        _loggedIn = true;
      }
    });
    print('Welcome $_loggedIn after');
    return _loggedIn;
  }
  Future<bool> init() async {
    // await Future.delayed(const Duration(seconds: 1));
    await _init();
    return true;
  }

}
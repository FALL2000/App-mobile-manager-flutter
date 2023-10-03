import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:x_money_manager/model/MA_User.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MaLocalStore {
    static  Future<SharedPreferences> _prefs  = SharedPreferences.getInstance();
    static SharedPreferences? prefs;

    static init() async{
        prefs ??= await _prefs; // if (prefs == null) await _prefs;
    }

    static storeData(String key, dynamic data,) async{
        init();
        await prefs?.setString(key, jsonEncode(data));
    }
    static storeUser(MaUser? user) async{
        init();
        await prefs?.setString('localUser', jsonEncode(user));
        await prefs?.setBool('hasLocalUser', user?.userId?.isNotEmpty ?? false);
    }
    static bool checkUserData(){
        init();
        return ( prefs?.containsKey('localUser') ?? false) && ( prefs?.getBool('hasLocalUser') ?? false) ;
    }

    static MaUser? getStoredUser() {
        init();
        MaUser? user;
        String _user= prefs?.getString('localUser') ?? '';
        if(_user.isNotEmpty){
          user= MaUser.fromJson(jsonDecode(_user));
        }
        
        return user;
    }
    static logOut() async{
        init();
        await prefs?.remove('hasLocalUser');
        await prefs?.remove('localUser');
    }


}
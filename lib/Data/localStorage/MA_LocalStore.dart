import 'dart:async';
import 'dart:convert';
// import 'package:x_money_manager/model/MA_User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_money_manager/Model/MA_User.dart';
class MaLocalStore {
    static  Future<SharedPreferences> _prefs  = SharedPreferences.getInstance();
    static SharedPreferences? prefs;

    static  Future<void> init() async{
        prefs ??= await _prefs; // if (prefs == null) await _prefs;
         print('------------SharedPreferences init-----------');
         print(prefs?.getKeys());
    }

    static  Future<void> storeData(String key, dynamic data,) async{
        init();
        await prefs?.setString(key, jsonEncode(data));
    }
    
    static  Future<void> storeDeviceToken(String token) async{
        await init();
        await prefs?.setString('fcmTokem', token);
    }
    static Future<String?> getStoredToken() async{
        await init();
        return prefs?.getString('fcmTokem');
    }
    static  Future<void> storeUser(MaUser user) async{
        init();
        await prefs?.setString('localUser', jsonEncode(user));
        await prefs?.setBool('hasLocalUser', user.userId?.isNotEmpty ?? false);
    }
    static bool checkUserData(){
        init();
        return ( prefs?.containsKey('localUser') ?? false) && ( prefs?.getBool('hasLocalUser') ?? false) ;
    }

    static Future<MaUser?> getStoredUser() async{
        await init();
        MaUser? user;
        String _user= prefs?.getString('localUser') ?? '';
        if(_user.isNotEmpty){
          Map<String,dynamic> map=jsonDecode(_user);
          map.forEach((key, value) { 
            print(' key $key value $value ');
          });          
          user= MaUser.fromJson(map);
        }
        
        return user;
    }
    static Future<void> logOut() async{
        print('------------clearing all localStorage---START-----------');
        await init();
        
        await prefs?.remove('hasLocalUser');
        await prefs?.remove('localUser');
         print('------------SharedPreferences logOut-----------');
         print(prefs?.getKeys());
        print('------------clearing all localStorage---END-----------');
    }


}
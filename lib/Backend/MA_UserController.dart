import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_FireFunctionsController.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Model/MA_Response.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';
// import 'package:x_money_manager/model/MA_User.dart'; 
import 'package:x_money_manager/Data/localStorage/MA_LocalStore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MaUserController {

  static Future<MaResponse> sendToken(String? token) async{
        var storedToken= await MaLocalStore.getStoredToken();
        if(storedToken==token){
          // token has already been sended to Firebase 
          return  MaResponse.successResponse(message: 'token has already been sended to Firebase');
        }
        var input = {
            "action": "NEW-DEVICE",
            "token": token
        };
        var result= await MaFireFunctionsController.call(MaConstants.CONST_FCMTOKEM_FUNCION, input);
        if(!result.error){
           await MaLocalStore.storeDeviceToken(token??'');
        }
        return result;
    }
    static Future<MaResponse> removeToken() async{
        var storedToken= await MaLocalStore.getStoredToken();
        if(storedToken?.isEmpty ?? false){
          return  MaResponse.successResponse(message: 'token removed from Firebase');
        }
        var input = {
            "action": "OLD-DEVICE",
            "token":  storedToken
        };

        var result= await MaFireFunctionsController.call(MaConstants.CONST_FCMTOKEM_FUNCION, input);
        return result;
    }
  static Future<MaResponse?> CompleteAccount( MaUser? user) async{
      if(user==null) return MaResponse.errorResponse(message: 'Empty user');
      user.userId=FirebaseAuth.instance.currentUser!.uid;
      var _input = user.toSave();
      // _input.update('userId', (value) => FirebaseAuth.instance.currentUser!.uid);
      // input.update(transfertId, (value) => transfertId);
      var input = {
          'action': 'SAVE',
          'user': _input
      };
      
      var result= await MaFireFunctionsController.call(MaConstants.CONST_USER_FUNCION, input);

      if(! result.error){
        await MaLocalStore.storeUser(user);
      }
      return result;
  }
  static Future<MaResponse> getProfile() async{
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ get profile');
      var input = {
          'action': 'GET-PROFILE',
      };
      
      var result= await MaFireFunctionsController.call(MaConstants.CONST_USER_FUNCION, input);
        print(result);
      if(! result.error){
        print(result.body);
        // await MaLocalStore.storeUser(user);
      }
      return result;
  }
  static Future<List<MaUser>> getAgents() async{
        
        const input = {
            'action': 'GET-ALL',
             'role': 'AGENT'
        };
        var result= await MaFireFunctionsController.call(MaConstants.CONST_USER_FUNCION, input);
        // debugPrint(result);
        List<MaUser> _agents=[];
        if (!result.error){
          for (var element in result.body) {
            _agents.add(MaUser.BuilfromJson(element));
          }

        }
        // debugPrint('###################### prinitng trans');
        // debugPrint(transactions.length);
        debugPrint('$_agents');
        
        return _agents;
  }
  static Future<List<MaUser>> getOpenAgents(String zoneId) async{
        debugPrint('#######getOpenAgents>>zoneId: $zoneId ');
        const input = {
            'action': 'GET-ALL',
             'role': 'AGENT'
        };
        var result= await MaFireFunctionsController.call(MaConstants.CONST_USER_FUNCION, input);
        // debugPrint(result);
        List<MaUser> _agents=[];
        if (!result.error){
          for (var element in result.body) {
            var _agent=MaUser.BuilfromJson(element);
            //  debugPrint('${_agent.toJson()}');
             debugPrint('-----_agent.countryId > ${_agent.countryId}');
            if(_agent.countryId==zoneId) 
              _agents.add(_agent);
          }

        }
        // debugPrint('###################### prinitng trans');
        // debugPrint(transactions.length);
        // debugPrint('$_agents');
        
        return _agents;
  }
  
  static Future<MaUser?> getUserInfo(String userId) async{
        debugPrint('#######getUserInfo>>userId: $userId ');
        var input = {
            'action': 'GET-INFO',
            'userId': userId
        };
        var result= await MaFireFunctionsController.call(MaConstants.CONST_USER_FUNCION, input);
        // debugPrint(result);
        if (!result.error){
          MaUser _agent =MaUser.BuilfromJson(result.body);
          debugPrint('${_agent.toJson()}');
          return _agent;
        }
  }

  static Future<MaResponse> updateUserInfo(data) async{
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ update user info');
    var input = {
      'action': 'UPDATE',
      'userId':FirebaseAuth.instance.currentUser!.uid,
      'user':data
    };

    var result= await MaFireFunctionsController.call(MaConstants.CONST_USER_FUNCION, input);
    print(result);
    if(! result.error){
      // print(result.body);
      // await MaLocalStore.storeUser(MaUser.fromJson(result.body));
    }
    return result;
  }

  static Future<MaResponse> updateUserPassword(newPassword) async{
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ update user password');
    var input = {
      'action': 'UPDATE',
      'userId':FirebaseAuth.instance.currentUser!.uid,
      'password': newPassword,
      'user': {}
    };

    var result= await MaFireFunctionsController.call(MaConstants.CONST_USER_FUNCION, input);
    print(result);
    if(! result.error){
      // print(result.body);
      // await MaLocalStore.storeUser(MaUser.fromJson(result.body));
    }
    return result;
  }

}
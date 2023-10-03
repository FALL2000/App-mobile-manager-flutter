import 'package:x_money_manager/Backend/MA_FireFunctionsController.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/model/MA_Response.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';
// import 'package:x_money_manager/model/MA_User.dart'; 
import 'package:x_money_manager/Data/localStorage/MA_LocalStore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MaUserController {

    static Future<MaResponse> sendToken(String? token) async{
        
        var input = {
            "action": "UPDATE",
            "user": {"fcmToken": token}
        };
        var result= await MaFireFunctionsController.call(MaConstants.CONST_USER_FUNCION, input);
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

}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Backend/MA_UserController.dart';
import 'package:x_money_manager/Data/localStorage/MA_LocalStore.dart';
import 'package:x_money_manager/Model/MA_User.dart';
// import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Model/MA_Response.dart';
import 'package:x_money_manager/Notification/MA_firebaseNotification.dart';
class MaLoginController {
      static Future<MaResponse> login(String emailAddress, String password) async{
        try {
          
          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
          var response= await MaUserController.getProfile();
          if(response.error==true) return  response;

          print('@@@@@-------------------------------');
          MaUser _user = MaUser.BuilfromJson(response.body);
          
          print(_user?.toString());
          print(_user.role);
          if(_user.role == Role.manager || _user.role == Role.admin) {
            _user.email = _user.email.isEmpty ? emailAddress : _user.email;
            await MaFirebaseNotification.getDeviceToken();
            await MaLocalStore.storeUser(_user);
            return MaResponse.successResponse(message: '',body: credential);
          }

          await signOut();
          return MaResponse.errorResponse(message:'bad role', body: response);
          
        } on FirebaseAuthException catch (e) {
          String message = e.message ?? '';
          print('@@@@@error login in message "${message}"');
          if (e.code == 'user-not-found') {
            // print('No user found for that email.');
            message='No user found for that email';
          } else if (e.code == 'wrong-password') {
            // print('Wrong password provided for that user.');
            message='Wrong password provided for that user';
          }else if (e.code == 'network-request-failed') {
            // print('Wrong password provided for that user.');
            message='network error';
          }
          


          // print('@@@@@error while login ${e.code}');
          print('@@@@@error login out message "$message"');

          return MaResponse.errorResponse(message:message, body: e);
        }
      }

      
      static Future<MaResponse> resetPassword(String emailAddress) async{
        try {
          
          await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress,);
          return MaResponse.successResponse(message: '',body: 'ok');
          
        } /*on FirebaseAuthException */catch (e) {
          // String message = e.message ?? '';
          String message = e.toString() ;
          print('@@@@@error login in message "${message}"');
          /*if (e.code == 'user-not-found') {
            // print('No user found for that email.');
            message='No user found for that email';
          } else if (e.code == 'wrong-password') {
            // print('Wrong password provided for that user.');
            message='Wrong password provided for that user';
          }else if (e.code == 'network-request-failed') {
            // print('Wrong password provided for that user.');
            message='network error';
          }*/
          


          // print('@@@@@error while login ${e.code}');
          print('@@@@@error login out message "$message"');

          return MaResponse.errorResponse(message:message, body: e);
        }
      }
}
Future<void> signOut() async{
  print('------------signOut---START-----------');
  await MaUserController.removeToken();
  await FirebaseAuth.instance.signOut();
  await MaLocalStore.logOut();
  await Get.deleteAll();
  print('------------signOut-----------');

}
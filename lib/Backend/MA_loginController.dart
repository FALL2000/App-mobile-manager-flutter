import 'package:firebase_auth/firebase_auth.dart';
import 'package:x_money_manager/Data/localStorage/MA_LocalStore.dart';
import 'package:x_money_manager/model/MA_Response.dart';
class MaLoginController {
      static Future<MaResponse> login(String emailAddress, String password) async{
        try {
          
          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
          return MaResponse.successResponse(message: '',body: credential);
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
      static Future<MaResponse> signUpWithEmailPassword(String emailAddress, String password) async{
          String message ='';
          var _e;
          try {
            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailAddress,
                password: password,
              );
            return MaResponse.successResponse(message: '',body: credential);
          } on FirebaseAuthException catch (e) {
            _e=e;
            message = e.message ?? '';
            if (e.code == 'weak-password') {
              message='The password provided is too weak.';
            } else if (e.code == 'email-already-in-use') {
              message='The account already exists for that email.';
            }
          } catch (e) {
            _e=e;
            message=e.toString();
            print(e);
          }
          


          // print('@@@@@error while login ${e.code}');
          print('@@@@@error login out message "$message"');

          return MaResponse.errorResponse(message:message, body: _e);
        
      }
}
signOut() async{FirebaseAuth.instance.signOut();
    await MaLocalStore.logOut();
}
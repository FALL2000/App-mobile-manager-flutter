import 'package:x_money_manager/Backend/MA_FireFunctionsController.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/model/MA_Request.dart';
import 'package:x_money_manager/model/MA_Response.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MATransactionsController {
    static Future<List<MaTransaction>> getAlltransactions() async{
        
        const input = {
            'action': 'GET-ALL'
        };
        var result= await MaFireFunctionsController.call(MaConstants.CONST_TRANS_FUNCION, input);
        // debugPrint(result);
        List<MaTransaction> transactions=[];
        if (!result.error){
          for (var element in result.body) {
            transactions.add(MaTransaction.fromJson(element));
          }

        }
        // debugPrint('###################### prinitng trans');
        // debugPrint(transactions.length);
        // debugPrint(transactions);
        
        return transactions;
    }
    static Future<MaTransaction?> getTransactionDetails( String transactionId) async{
        var input = {
           'action': 'GET-INFO',
            'transfertId': transactionId
        };
        // input.update(transfertId, (value) => transfertId);
        var result= await MaFireFunctionsController.call(MaConstants.CONST_TRANS_FUNCION, input);
        // debugPrint(result);
        // MaTransaction transaction=null;
        if (!result.error){
          
          return MaTransaction.fromJson(result.body);
        }else{
          throw new Exception(result.message??'not found');
        }
        
    }
    /*
    static Future<MaResponse?> saveTransfert( MaTransaction? request) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
      // request.status=RequestStatus.;
      var _input = request?.toSave();
      _input?.update('ownerId', (value) => FirebaseAuth.instance.currentUser!.uid);
      // input.update(transfertId, (value) => transfertId);
      var input = {
          'action': 'SAVE',
          'transfert': _input
      };
      
      var result= await MaFireFunctionsController.call(MaConstants.CONST_TRANS_FUNCION, input);
      return result;
    }
    static Future<MaResponse> updateTransfert( MaTransaction? request, String requestId) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
        var _input = request?.toSave();
        _input?.update('ownerId', (value) => FirebaseAuth.instance.currentUser!.uid);
        // input.update(transfertId, (value) => transfertId);
        var input = {
           'action': 'UPDATE',
            'transfert': _input,
            'transfertId': requestId,
        };
        
        var result= await MaFireFunctionsController.call(MaConstants.CONST_TRANS_FUNCION, input);
        return result;
    }
    static Future<MaResponse> approveTransaction(MaTransaction? request) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
       var input = {
           'action': 'UPDATE-APPROVAL-STATUS',
            // 'transfertId': request.requestId,
            'status': RequestStatus.approved.keyValue,
            // 'approvalId': request.approvalId,
        };
        
      var result= await MaFireFunctionsController.call(MaConstants.CONST_TRANS_FUNCION, input);
      return result;
    }
    static Future<MaResponse> rejectTransaction(MaTransaction? request,String? note, bool andClose) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
       var input = {
           'action': 'UPDATE-APPROVAL-STATUS',
            // 'transfertId': request.requestId,
            // 'approvalId': request.approvalId,
            'userNote':note,
            'status': andClose?  RequestStatus.canceled.keyValue : RequestStatus.rejected.keyValue,
        };
        
      var result= await MaFireFunctionsController.call(MaConstants.CONST_TRANS_FUNCION, input);
      return result;
    }
    static  Future<MaResponse> deleteTransaction(MaTransaction? request) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
      var _input = {
            'status': RequestStatus.canceled.keyValue,
        };
       var input = {
           'action': 'UPDATE',
            'transfert': _input,
            // 'transfertId': request.requestId,
        };
        
      var result= await MaFireFunctionsController.call(MaConstants.CONST_TRANS_FUNCION, input);
      if(!result.error) result.message='Delete operation finished successfully';
      return result;
    }*/
}


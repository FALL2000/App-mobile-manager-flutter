import 'package:x_money_manager/Backend/MA_FireFunctionsController.dart';
import 'package:x_money_manager/model/MA_Request.dart';
import 'package:x_money_manager/model/MA_Response.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MATransactionsController {
    static Future<List<MaRequest>> getAlltransferts() async{
        
        const input = {
            'action': 'GET-ALL'
        };
        var result= await MaFireFunctionsController.call(MaConstants.CONST_REQ_FUNCION, input);
        // print(result);
        List<MaRequest> transactions=[];
        if (!result.error){
          for (var element in result.body) {
            transactions.add(MaRequest.fromJson(element));
          }

        }
        print('###################### prinitng trans');
        print(transactions.length);
        // result.body=countries;
        
        return transactions;
    }
    static Future<MaRequest?> getTransfert( String transfertId) async{
        var input = {
           'action': 'GET-INFO',
            'transfertId': transfertId
        };
        // input.update(transfertId, (value) => transfertId);
        var result= await MaFireFunctionsController.call(MaConstants.CONST_REQ_FUNCION, input);
        // print(result);
        // MaRequest transaction=null;
        if (!result.error){
          
          return MaRequest.fromJson(result.body);
        }else{
          throw new Exception(result.message??'not found');
        }
        
        return null;
    }
    static Future<MaResponse?> saveTransfert( MaRequest? request) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
      request.status=RequestStatus.open;
      var _input = request?.toSave();
      _input?.update('ownerId', (value) => FirebaseAuth.instance.currentUser!.uid);
      // input.update(transfertId, (value) => transfertId);
      var input = {
          'action': 'SAVE',
          'transfert': _input
      };
      
      var result= await MaFireFunctionsController.call(MaConstants.CONST_REQ_FUNCION, input);
      return result;
    }
    static Future<MaResponse> updateTransfert( MaRequest? request, String requestId) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
        var _input = request?.toSave();
        _input?.update('ownerId', (value) => FirebaseAuth.instance.currentUser!.uid);
        // input.update(transfertId, (value) => transfertId);
        var input = {
           'action': 'UPDATE',
            'transfert': _input,
            'transfertId': requestId,
        };
        
        var result= await MaFireFunctionsController.call(MaConstants.CONST_REQ_FUNCION, input);
        return result;
    }
    static Future<MaResponse> approveTransaction(MaRequest? request) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
       var input = {
           'action': 'UPDATE-APPROVAL-STATUS',
            'transfertId': request.requestId,
            'status': RequestStatus.approved.keyValue,
            'approvalId': request.approvalId,
        };
        
      var result= await MaFireFunctionsController.call(MaConstants.CONST_REQ_FUNCION, input);
      return result;
    }
    static Future<MaResponse> rejectTransaction(MaRequest? request,String? note, bool andClose) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
       var input = {
           'action': 'UPDATE-APPROVAL-STATUS',
            'transfertId': request.requestId,
            'approvalId': request.approvalId,
            'userNote':note,
            'status': andClose?  RequestStatus.canceled.keyValue : RequestStatus.rejected.keyValue,
        };
        
      var result= await MaFireFunctionsController.call(MaConstants.CONST_REQ_FUNCION, input);
      return result;
    }
    static  Future<MaResponse> deleteTransaction(MaRequest? request) async{
      if(request==null) return MaResponse.errorResponse(message: 'Empty request');
      var _input = {
            'status': RequestStatus.canceled.keyValue,
        };
       var input = {
           'action': 'UPDATE',
            'transfert': _input,
            'transfertId': request.requestId,
        };
        
      var result= await MaFireFunctionsController.call(MaConstants.CONST_REQ_FUNCION, input);
      if(!result.error) result.message='Delete operation finished successfully';
      return result;
    }
}


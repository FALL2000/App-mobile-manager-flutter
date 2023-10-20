// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:x_money_manager/Model/MA_Response.dart';
class MaFireFunctionsController {
    static Future<MaResponse> call(String funcName, dynamic data) async{
      print('@@@@=====> calling firebase $funcName');
      try {
          print('@@@@=====>With data: ${jsonEncode(data)}');
          final result = await FirebaseFunctions.instance.httpsCallable(funcName).call(data);
          dynamic _data= result.data;
          String _message= _data['message'] as String;
          if(_data['exit']=='KO'){
              return MaResponse.errorResponse(message:_message, body: null, code: _data['code']);
          }
          return MaResponse.successResponse(message: _data['message'],body: _data['body']);
        } on FirebaseFunctionsException catch (error) {
          print(error.code);
          print(error.details);
          print(error.message);
          return MaResponse.errorResponse(message:error.message??'', body: null, code: error.code);
        }
    }
}
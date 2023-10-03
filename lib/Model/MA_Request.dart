// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:x_money_manager/model/MA_Zone.dart';
import 'package:intl/intl.dart';
enum RequestStatus {
    open('OPEN'),
    inapproval('IN APPROVAL'),
    inprogress('IN PROGRESS'),
    approved('APPROVED'),
    canceled('CANCELED'),
    rejected('REJECTED'),
    closedwon('CLOSED WON');

  final String keyValue;
  const  RequestStatus( this.keyValue);
  bool get isOpen=> this==RequestStatus.open;
  bool get isPending=> this==RequestStatus.inapproval;
  bool get isClosed=> this==RequestStatus.canceled;
  bool get isSuccess=> this==RequestStatus.closedwon;
  bool get isInProggress=> this==RequestStatus.inprogress || this==RequestStatus.approved;

  static RequestStatus? assignStatus(String key){

    return RequestStatus.values.firstWhere((element) => element.keyValue==key);

  }
  // bool operator <(RequestStatus status) => keyValue < status.keyValue;
  // bool operator >(RequestStatus status) => keyValue > status.keyValue;
}
class MaRequest {
  String amount='0';
  bool toBank=false;
  String codeReception; //
  String? createdDate; //
  RequestStatus? status; //
  String? requestId ;//
  userReceiver? receiptInfo;
  approvalRequest? currentApproval;
  bankReceiver? bankInfo;
  MaCountry? inCountry;
  MaCity? incity;
  MaCity? outcity;
  MaCountry? outCountry;
  MaRequest({required  this.amount, required this.codeReception,required this.toBank,
                        this.status, this.requestId,this.createdDate,
                        this.receiptInfo, this.bankInfo,
                        this.inCountry, this.incity,
                        this.outCountry, this.outcity, this.currentApproval}
            );
  get id => requestId ?? codeReception;
  set id(value)=> requestId=value;
  get from=> '${incity?.name}, ${inCountry?.name}';
  get to=> '${outcity?.name}, ${outCountry?.name}';
  String get approvalId=> currentApproval?.id ??'';
  bool get isNew=> (requestId!=null) ? false : true;
  bool get isEditable=> status!.isOpen ;
  bool get isFinal=> status!.isClosed ||  status!.isSuccess;
  bool get isPending=> status!.isPending && hasApproval;
  bool get isDeletable=> !status!.isInProggress && !isPending && !status!.isClosed;
  // bool get isDeletable=> status!.isOpen || status!.isSuccess;
  bool get hasApproval=> approvalId.isNotEmpty;
  String get formattedamount=> NumberFormat.simpleCurrency(name: (currencycode )).format(double.parse(amount));
  String get formattedfees=> NumberFormat.simpleCurrency(name: (currencycode )).format(double.parse(currentApproval?.fees ?? '0'));
  String get formattedDate {
      try {
            return DateFormat.yMMMEd().add_jm().format(DateTime.parse(createdDate??'')); 
          } catch (e) {
            print(e); 
          } 
      return '';
  }
  String get formattedTotal {
      try {
            double fees= double.parse(currentApproval?.fees ?? '0');
            double _amount= double.parse(amount);
            return NumberFormat.simpleCurrency(name: (currencycode )).format(_amount+fees);
          } catch (e) {
            print(e); 
          } 
      return '';
  }
    
  // bool get isClosed=> status==RequestStatus.canceled;
  // bool get isSuccess=> status==RequestStatus.closedwon;
  // bool get isInProggress=> status==RequestStatus.inprogress || status==RequestStatus.approved;
  get currencycode=> inCountry!.currencyCode ?? '';
  @override
  String toString() => "(id=$id, codeReception=$codeReception, amount=$amount, toBank=$toBank, status=$status, createdDate=$createdDate,  approval=${currentApproval?.toString()},  receiptInfo=${receiptInfo.toString()}, bankInfo=${bankInfo.toString()} , inCountry=${inCountry.toString()}, incity=${incity.toString()}, outCountry=${outCountry.toString()}, outcity=${outcity.toString()} )";


 factory MaRequest.fromJson(Map<Object?, Object?> json){

      print('@@@@@@@@@@@@++++++');
      print(json);
      Map<Object?, Object?> inzone= jsonDecode( jsonEncode(json['inZone']??{}));
      Map<Object?, Object?> outzone= jsonDecode( jsonEncode(json['outZone']??{}));
      Map<Object?, Object?> createdDate= jsonDecode( jsonEncode(json['createdDate']??{}));
      var _seconds=0;
      var date=null;
      if(createdDate['_seconds']!=null){  
          _seconds=int.parse(util.toSString(createdDate['_seconds']));
          _seconds=_seconds*1000;  
          date = new DateTime.fromMillisecondsSinceEpoch(_seconds).toString();  
      }
      return MaRequest(
        amount: util.toSString(json['amount']),
        codeReception: util.toSString(json['codeReception']),
        toBank: json['to_bank'] as bool,
        bankInfo: bankReceiver.fromJson(jsonDecode( jsonEncode(json['bank'] ?? {}))),// bankReceiver.fromJson(json['']),
        currentApproval: approvalRequest.fromJson(jsonDecode( jsonEncode(json['approval'] ?? {}))),// bankReceiver.fromJson(json['']),
        createdDate: date,
        inCountry: MaCountry.fromJson(jsonDecode( jsonEncode(inzone['country']??{}))),
        incity: MaCity.fromJson(inzone),
        outCountry:  MaCountry.fromJson(jsonDecode( jsonEncode(outzone['country']??{}))),
        outcity: MaCity.fromJson(outzone),
        receiptInfo: userReceiver.fromJson(jsonDecode( jsonEncode(json['receiver'] ?? {}))),
        requestId: util.toSString(json['id']),
        status: RequestStatus.assignStatus(util.toSString(json['status'])),
      );





  } 

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'toBank': toBank,
        'codeReception': codeReception,
        'createdDate': createdDate,
        'status': status,
        'requestId': requestId,
        'receiptInfo': receiptInfo?.toJson(),
        'approvql': currentApproval?.toJson(),
        'bankInfo': bankInfo?.toJson(),
        'inCountry': inCountry?.toJson(),
        'incity': incity?.toJson(),
        'outcity': outcity?.toJson(),
        'outCountry': outCountry?.toJson(),
      };

    Map<String, dynamic> toSave(){
      var input= {
        'amount': int.parse(amount),
        'to_bank': toBank,
        'bank':null,
        'receiver':null,
        // 'bank': bankInfo?.toJson(),
        'codeReception': codeReception,
        'inZoneCity': incity?.id,
        'outZoneCity': outcity?.id,
        // 'receiver': receiptInfo?.toJson(),
        'ownerId' : '',//to set
        // 'createdDate': createdDate,
        'status': status?.keyValue,
        // 'requestId': requestId,
        'inCountry': inCountry?.toJson(),
        'incity': incity?.toJson(),
        'outcity': outcity?.toJson(),
        'outCountry': outCountry?.toJson(),
      };
      if(toBank){
        input.update('bank', (value) => bankInfo?.toJson());
      }else{
         input.update('receiver', (value) => receiptInfo?.toJson());
      }

      return input;
    }
}
class partInfo {
  // String amount,country,incityId;
  String? amount='0';
  String? inCountryId;
  String? incityId;
  String? outCountryId;
  String? outcityId;
  partInfo(
        {
        this.amount,
        this.inCountryId,
        this.incityId,
        this.outCountryId,
        this.outcityId
        }
        );
  @override
  String toString() => "(amount=$amount, inCountryId=$inCountryId, incityId=$incityId, outCountryId=$outCountryId, outcityId=$outcityId )";
}
class part2Info {
  // String amount,country,incityId;
  bool? toBank=false;
  String? codeReception; //
  userReceiver? receiptInfo;
  bankReceiver? bankInfo;
  part2Info({this.codeReception,this.toBank,this.receiptInfo,this.bankInfo,} );
  @override
  String toString() => "(codeReception=$codeReception, toBank=$toBank, receiptInfo=${receiptInfo.toString()}, bankInfo=${bankInfo.toString()})";
}
class userReceiver {
  // String amount,country,incityId;
  // bool? toBank=false;
  String? name='';
  String? phone;
  userReceiver({this.name,this.phone});
  factory userReceiver.fromJson(Map<Object?, Object?> json){
      return userReceiver(
        // toBank : json['toBank'] as bool,
        name : util.toSString(json['name']),
        phone : util.toSString(json['phone'])
      );
  } 

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        // 'toBank': toBank,
      };
  @override
  String toString() => "(name=$name, phone=$phone )";
}
class bankReceiver {
  // String amount,country,incityId;
  // bool? toBank=false;
  String? name='';
  String? title='';
  String? number='';
  bankReceiver({ this.name,this.title,this.number, } );
  @override
  String toString() => "(name=$name,title=$title, number=$number )";
  factory bankReceiver.fromJson(Map<Object?, Object?> json){
      return bankReceiver(
        name :util.toSString(json['nom']),// json['name'] as bool,
        title : util.toSString(json['intitule']),
        number : util.toSString(json['numero'])
      );
  } 

  Map<String, dynamic> toJson() => {
        'nom': name,
        'intitule': title,
        'numero': number,
      };
}


class approvalRequest {
  // String amount,country,incityId;
  // bool? toBank=false;
  String? id='';
  String? startDate='';
  String? fees='';
  approvalRequest({ this.id,this.startDate,this.fees, } );
  String get formattedDate {
      try {
            return DateFormat.yMMMEd().add_jm().format(DateTime.parse(startDate??'')); 
          } catch (e) {
            print(e); 
          } 
      return '';
  }
  @override
  String toString() => "(id=$id,startDate=$startDate, fees=$fees )";
  factory approvalRequest.fromJson(Map<Object?, Object?> json){
      return approvalRequest(
        id :util.toSString(json['id']),// json['id'] as bool,
        startDate : util.toSString(json['startDate']),
        fees : util.toSString(json['fees'])
      );
  } 

  Map<String, dynamic> toJson() => {
        'id': id,
        'startDate': startDate,
        'fees': fees,
      };
}

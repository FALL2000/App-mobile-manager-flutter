// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:x_money_manager/model/MA_Zone.dart';
import 'package:intl/intl.dart';
enum TransactionStatus {
    // open('OPEN'),
    inapproval('IN APPROVAL'),
    inprogress('IN PROGRESS'),
    approved('APPROVED'),
    canceled('CANCELED'),
    // rejected('REJECTED'),
    closedwon('CLOSED');
    /**
     *  InApproval = 'IN APPROVAL', //without managers and not approved
    Approved = 'APPROVED', // all approval request are approved, need to assign manager
    Canceled = 'CANCELED', //one approval was cancel
    Queued = 'QUEUED', // Waiting for manager
    InProgress = 'IN PROGRESS', // manager already assigned
    Closed = 'CLOSED', //success
     */

  final String keyValue;
  const  TransactionStatus( this.keyValue);
  // bool get isOpen=> this==TransactionStatus.open;
  // bool get isPending=> this==TransactionStatus.inapproval;
  bool get isClosed=> this==TransactionStatus.canceled;
  bool get isSuccess=> this==TransactionStatus.closedwon;
  bool get isInProggress=> this==TransactionStatus.inprogress || this==TransactionStatus.approved;

  static TransactionStatus? assignStatus(String key){

    return TransactionStatus.values.firstWhere((element) => element.keyValue==key);

  }
  // bool operator <(TransactionStatus status) => keyValue < status.keyValue;
  // bool operator >(TransactionStatus status) => keyValue > status.keyValue;
}
class MaTransaction {
  String amount='0';
  String convertedAmount='0';
  String? participants='0';
  // bool toBank=false;
  String code; //
  String? createdDate; //
  String? endDate; //
  TransactionStatus? status; //
  String? transactionId ;//
  String? comment ;//
  String? reason ;//
  // userReceiver? receiptInfo;
  List<approvalTransaction>? approvals;
  gapInfo? gap;
  MaCountry? inCountry;
  // MaCity? incity;
  // MaCity? outcity;
  MaCountry? outCountry;
  MaTransaction({         required  this.amount, required this.code, 
                          this.gap, this.status, this.transactionId,
                          this.createdDate, this.endDate,
                          this.comment, this.reason,
                          this.approvals,
                        // required this.toBank,
                        // this.receiptInfo,
                        this.inCountry, 
                        this.participants,
                        this.outCountry, 
                        // this.outcity,
                        }
            );
  get id => transactionId ?? code;
  set id(value)=> transactionId=value;
  get from=> '${inCountry?.name}';
  get to=> '${outCountry?.name}';
  // String get approvalId=> currentApproval?.id ??'';
  bool get isNew=> (transactionId!=null) ? false : true;
  // bool get isEditable=> status!.isOpen ;
  bool get isFinal=> status!.isClosed ||  status!.isSuccess;
  // bool get isPending=> status!.isPending && hasApproval;
  // bool get isDeletable=> !status!.isInProggress && !isPending && !status!.isClosed;
  // // bool get isDeletable=> status!.isOpen || status!.isSuccess;
  // bool get hasApproval=> approvalId.isNotEmpty;
  String get formattedamount=> NumberFormat.simpleCurrency(name: (currencycode )).format(double.parse(amount??'0'));
  // String get formattedfees=> NumberFormat.simpleCurrency(name: (currencycode )).format(double.parse(currentApproval?.fees ?? '0'));
  String get formattedDate {
      try {
            return DateFormat.yMMMEd().add_jm().format(DateTime.parse(createdDate??'')); 
          } catch (e) {
            print(e); 
          } 
      return '';
  }
  // String get formattedTotal {
  //     try {
  //           double fees= double.parse(currentApproval?.fees ?? '0');
  //           double _amount= double.parse(amount);
  //           return NumberFormat.simpleCurrency(name: (currencycode )).format(_amount+fees);
  //         } catch (e) {
  //           print(e); 
  //         } 
  //     return '';
  // }
    
  // bool get isClosed=> status==TransactionStatus.canceled;
  // bool get isSuccess=> status==TransactionStatus.closedwon;
  // bool get isInProggress=> status==TransactionStatus.inprogress || status==TransactionStatus.approved;
  get currencycode=> outCountry!.currencyCode ?? '';
  @override
  String toString() => "(id=$id, code=$code, amount=$amount, endDate=$endDate, status=$status, createdDate=$createdDate,   gap=${gap.toString()} , inCountry=${inCountry.toString()}, outCountry=${outCountry.toString()} )";


 factory MaTransaction.fromJson(Map<Object?, Object?> json){

      print('@@@@@@@@@@@@++++++');
      print(json);
      Map<Object?, Object?> additionalInfo= jsonDecode( jsonEncode(json['additionalInfo']??{}));
      
      Map<Object?, Object?> inzone= jsonDecode( jsonEncode(additionalInfo['inZone'] ?? {}));
      Map<Object?, Object?> outzone= jsonDecode( jsonEncode(additionalInfo['outZone'] ?? {}));
      // Map<Object?, Object?> createdDate= jsonDecode( jsonEncode(json['createdDate']??{}));
      // var _seconds=0;
      // var date=null;
      // if(createdDate['_seconds']!=null){  
      //     _seconds=int.parse(util.toSString(createdDate['_seconds']));
      //     _seconds=_seconds*1000;  
      //     date = new DateTime.fromMillisecondsSinceEpoch(_seconds).toString();  
      // }
      
      return MaTransaction(

        amount: (additionalInfo['convertedAmount']?.toString() )?? '0',
        participants: (additionalInfo['participants']?.toString() )?? '0',
        code: util.toSString(json['code']),
        // toBank: json['to_bank'] as bool,
        gap: gapInfo.fromJson(jsonDecode( jsonEncode(additionalInfo['gap'] ?? {}))),// gapInfo.fromJson(json['']),
        // currentApproval: approvalTransaction.fromJson(jsonDecode( jsonEncode(json['approval'] ?? {}))),// gapInfo.fromJson(json['']),
        createdDate: util.toSString(json['startDate']),//date,
        endDate: util.toSString(json['endDate']),//date,
        inCountry: MaCountry.fromJson(inzone),
        // incity: MaCity.fromJson(inzone),
        outCountry:  MaCountry.fromJson(outzone),
        // receiptInfo: userReceiver.fromJson(jsonDecode( jsonEncode(json['receiver'] ?? {}))),
        transactionId: util.toSString(json['id']),
        status: TransactionStatus.assignStatus(util.toSString(json['status'])),
      );





  } 

  Map<String, dynamic> toJson() => {
        'amount': amount,
        // 'toBank': toBank,
        'code': code,
        'createdDate': createdDate,
        'status': status,
        'transactionId': transactionId,
        // 'receiptInfo': receiptInfo?.toJson(),
        // 'approvql': currentApproval?.toJson(),
        'gap': gap?.toJson(),
        'inCountry': inCountry?.toJson(),
        // 'incity': incity?.toJson(),
        // 'outcity': outcity?.toJson(),
        'outCountry': outCountry?.toJson(),
      };

    Map<String, dynamic> toSave(){
      var input= {
        'amount': int.parse(amount),
        // 'to_bank': toBank,
        // 'bank':null,
        // 'receiver':null,
        // // 'bank': gap?.toJson(),
        // 'code': code,
        // 'inZoneCity': incity?.id,
        // 'outZoneCity': outcity?.id,
        // // 'receiver': receiptInfo?.toJson(),
        // 'ownerId' : '',//to set
        // // 'createdDate': createdDate,
        // 'status': status?.keyValue,
        // // 'transactionId': transactionId,
        // 'inCountry': inCountry?.toJson(),
        // 'incity': incity?.toJson(),
        // 'outcity': outcity?.toJson(),
        // 'outCountry': outCountry?.toJson(),
      };
      // if(toBank){
      //   input.update('bank', (value) => gap?.toJson());
      // }else{
      //    input.update('receiver', (value) => receiptInfo?.toJson());
      // }

      return input;
    }
}




class gapInfo {
  // String amount,country,incityId;
  // bool? toBank=false;
  String? amount='';
  String? currency='';
  gapInfo({ this.amount,this.currency } );
  @override
  String toString() => "(amount=$amount,currency=$currency )";
  factory gapInfo.fromJson(Map<Object?, Object?> json){
      return gapInfo(
        amount :util.toSString(json['amount']),// json['name'] as bool,
        currency : util.toSString(json['currency']),
      );
  } 

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
      };
}


class approvalTransaction {
  // String amount,country,incityId;
  // bool? toBank=false;
  String? id='';
  String? startDate='';
  String? fees='';
  approvalTransaction({ this.id,this.startDate,this.fees, } );
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
  factory approvalTransaction.fromJson(Map<Object?, Object?> json){
      return approvalTransaction(
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

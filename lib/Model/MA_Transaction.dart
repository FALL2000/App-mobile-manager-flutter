// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Model/MA_User.dart';
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
enum ApprovalStatus {
    // open('OPEN'),
    inapproval('IN APPROVAL'),
    inprogress('IN PROGRESS'),
    approved('APPROVED'),
    canceled('CANCELED'),
    rejected('REJECTED'),
    closedwon('CLOSED WON'),
    error('ERROR');
    /**
     *  
     * xexport enum StatusApproval  {
    Open = 'NEW',//send to client
    InApproval = 'IN APPROVAL',//send to client
    InProgress = 'IN PROGRESS',//took in charge by agent 
    Approved = 'APPROVED',
    Rejected = 'REJECTED',
    Canceled = 'CANCELED',
    ClosedWon = 'CLOSED WON',
    Error = 'ERROR'
}
     */

  final String keyValue;
  const  ApprovalStatus( this.keyValue);
  // bool get isOpen=> this==TransactionStatus.open;
  // bool get isPending=> this==TransactionStatus.inapproval;
  bool get isClosed=> this==ApprovalStatus.canceled;
  bool get isSuccess=> this==ApprovalStatus.closedwon;
  bool get isInProggress=> this==ApprovalStatus.inprogress || this==ApprovalStatus.approved;

  static ApprovalStatus? assignStatus(String key){

    return ApprovalStatus.values.firstWhere((element) => element.keyValue==key);

  }
  // bool operator <(TransactionStatus status) => keyValue < status.keyValue;
  // bool operator >(TransactionStatus status) => keyValue > status.keyValue;
}
class MaTransaction {
  String amount='0';
  String convertedAmount='0';
  String? participants='0';
  String code; //
  String? createdDate; //
  String? endDate; //
  TransactionStatus? status; //
  String? transactionId ;//
  String? comment ;//
  String? reason ;//
  List<approvalTransaction>? approvals;
  gapInfo? gap;
  MaCountry? inCountry;
  MaCountry? outCountry;
  MaTransaction({         required  this.amount, required this.code, 
                          this.gap, this.status, this.transactionId,
                          this.createdDate, this.endDate,
                          this.comment, this.reason,
                          this.approvals,
                          required this.convertedAmount,
                        this.inCountry, 
                        this.participants,
                        this.outCountry, 
                        }
            );
  get id => transactionId ?? code;
  set id(value)=> transactionId=value;
  get from=> '${inCountry?.name}';
  get to=> '${outCountry?.name}';
  bool get isNew=> (transactionId!=null) ? false : true;
  bool get isFinal=> status!.isClosed ||  status!.isSuccess;
  MaUser? InZoneAgent;
  MaUser? outZoneAgent;
  String get formattedamount=> NumberFormat.simpleCurrency(name: (inCurrencycode )).format(double.parse(amount??'0'));
  String get formattedOutAmount=> NumberFormat.simpleCurrency(name: (currencycode )).format(double.parse(convertedAmount??'0'));
  String get formattedgap=> NumberFormat.simpleCurrency(name: (gapCurrencycode )).format(double.parse(gap!.amount??'0'));
  // String get formattedfees=> NumberFormat.simpleCurrency(name: (currencycode )).format(double.parse(currentApproval?.fees ?? '0'));
  String get formattedDate {
      try {
            return DateFormat.yMMMEd().add_jm().format(DateTime.parse(createdDate??'')); 
          } catch (e) {
            print(e); 
          } 
      return '';
  }
  List<approvalTransaction> get InZoneDetails {
      return approvalsByZone(inCountry?.id);
  }
  List<approvalTransaction> get outZoneDetails {
      return approvalsByZone(outCountry?.id);
  }

  List<approvalTransaction>  approvalsByZone(String? zoneId) {
      try {
            return approvals?.where((element) => 
              element.inCountry?.id == zoneId 
            ).toList() ?? []; 
          } catch (e) {
            print(e); 
          } 
      return [];
  }
  bool get hasInAgent=> (InZoneAgent!=null) ? true : false;
  bool get hasOutAgent=> (outZoneAgent!=null) ? true : false;
  get currencycode=> outCountry!.currencyCode ?? '';
  get inCurrencycode=> inCountry!.currencyCode ?? '';
  get gapCurrencycode=> gap!.currency ?? '';
  @override
  String toString() => "(id=$id, code=$code, amount=$amount, endDate=$endDate, status=$status, createdDate=$createdDate,   gap=${gap.toString()} , inCountry=${inCountry.toString()}, outCountry=${outCountry.toString()} , approvals=${approvals.toString()} )";


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
      List<approvalTransaction> _approvals = [];

      if(json['approvals']!=null){
        for (var element in json['approvals'] as List<dynamic>) {
          _approvals.add(approvalTransaction.buildJson(element));
        }
      }
      var trs= MaTransaction(

        amount: (additionalInfo['totalAmount']?.toString() )?? '0',
        convertedAmount: (additionalInfo['convertedAmount']?.toString() )?? '0',
        participants: (additionalInfo['participants']?.toString() )?? '0',
        code: util.toSString(json['code']),
        // toBank: json['to_bank'] as bool,
        gap: gapInfo.fromJson(jsonDecode( jsonEncode(additionalInfo['gap'] ?? {}))),// gapInfo.fromJson(json['']),
        // currentApproval: approvalTransaction.fromJson(jsonDecode( jsonEncode(json['approval'] ?? {}))),// gapInfo.fromJson(json['']),
        createdDate: util.toSString(json['startDate']),//date,
        endDate: util.toSString(json['endDate']),//date,
        inCountry: MaCountry.fromJson(inzone),
        // incity: MaCity.fromJson(inzone),
        approvals: _approvals,
        outCountry:  MaCountry.fromJson(outzone),
        // receiptInfo: userReceiver.fromJson(jsonDecode( jsonEncode(json['receiver'] ?? {}))),
        transactionId: util.toSString(json['id']),
        status: TransactionStatus.assignStatus(util.toSString(json['status'])),
      );

    trs.InZoneAgent= trs.InZoneDetails.firstWhereOrNull((element) => element.agentId?.isNotEmpty ?? false)?.agent;
    trs.outZoneAgent= trs.outZoneDetails.firstWhereOrNull((element) => element.agentId?.isNotEmpty ?? false)?.agent;

      return trs;



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
  String get formattedamount=> NumberFormat.simpleCurrency(name: (currency )).format(double.parse(amount??'0'));
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
  String? amount='';
  String? ownerId='';
  String? agentId='';
  String? requestId='';
  ApprovalStatus? status; //
  
  MaUser? owner;
  MaUser? agent;
  MaCountry? inCountry;
  MaCity? incity;
  MaCity? outcity;
  MaCountry? outCountry;
  approvalTransaction({ this.id,this.startDate,this.fees,this.inCountry,this.incity,this.outcity
          ,this.outCountry
          ,this.amount
          ,this.owner
          ,this.agent
          ,this.status
          ,this.ownerId
          ,this.agentId
          ,this.requestId
  } );
  String get formattedDate {
      try {
            return DateFormat.yMMMEd().add_jm().format(DateTime.parse(startDate??'')); 
          } catch (e) {
            print(e); 
          } 
      return '';
  }
  String get formattedamount=> NumberFormat.simpleCurrency(name: (currencycode )).format(double.parse(amount??'0'));
  String get formattedfees=> NumberFormat.simpleCurrency(name: (currencycode )).format(double.parse(fees ?? '0'));
  
  String get formattedTotal {
      try {
            double fees= double.parse(this.fees ?? '0');
            double _amount= double.parse(this.amount ?? '0');
            return NumberFormat.simpleCurrency(name: (currencycode )).format(_amount+fees);
          } catch (e) {
            print(e); 
          } 
      return '';
  }
  get currencycode=> inCountry!.currencyCode ?? '';
  @override
  String toString() => '(id=$id,startDate=$startDate,status=$status, fees=$fees, amount=$amount, ownerId=$ownerId,  owner=${owner?.toJson()}, agentId=$agentId,  agent=${agent?.toJson()}, '
                              +'requestId=$requestId, inCountry=$inCountry,  inCountry=${inCountry.toString()}, outCountry=${outCountry.toString()} )';
  factory approvalTransaction.fromJson(Map<Object?, Object?> json){
      return approvalTransaction(
        id :util.toSString(json['id']),// json['id'] as bool,
        startDate : util.toSString(json['startDate']),
        fees : util.toSString(json['fees'])
      );
  } 
  factory approvalTransaction.buildJson(Map<Object?, Object?> json){
    Map<Object?, Object?> transfert= jsonDecode( jsonEncode(json['transfert']??{}));
    Map<Object?, Object?> owner= jsonDecode( jsonEncode(transfert['owner']??{}));
    Map<Object?, Object?> agent= jsonDecode( jsonEncode(transfert['agent']??{}));
      var _app= approvalTransaction(
        id :util.toSString(json['id']),// json['id'] as bool,
        startDate : util.toSString(json['startDate']),
        fees : util.toSString(json['fees']),
        amount : util.toSString(transfert['amount']),
        ownerId : util.toSString(transfert['ownerId']),
        agentId : util.toSString(json['agentId']),
        owner: MaUser.BuilfromJson(owner),
        agent: MaUser.BuilfromJson(agent),
        requestId : util.toSString(transfert['id']),
        inCountry: MaCountry(id: util.toSString(transfert['inZoneId']), name: util.toSString(transfert['inZoneName']), currencyCode: util.toSString(transfert['inZoneCurrency'])),
        // incity: MaCity()
        // outcity: 
        status: ApprovalStatus.assignStatus(util.toSString(json['status'])),
        outCountry: MaCountry(id: util.toSString(transfert['outZoneId']), name: util.toSString(transfert['outZoneName']), currencyCode: util.toSString(transfert['outZoneCurrency'])),
      );
      _app.owner?.userId= util.toSString(transfert['ownerId']);
      _app.agent?.userId= _app.agentId;
      return _app;
  } 


  Map<String, dynamic> toJson() => {
        'id': id,
        'startDate': startDate,
        'fees': fees,
      };
}

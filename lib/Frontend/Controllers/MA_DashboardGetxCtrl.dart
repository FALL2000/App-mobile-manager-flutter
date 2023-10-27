// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:ffi';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_TransactionsController.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Utilities/MA_TransactionUtils.dart';
class MADashboardGetxCtrl extends GetxController { 
  List<MaTransaction> _transactions=[];
  bool get hasTransactions => _transactions.isNotEmpty;
  List<MaTransaction> get Transactions => _transactions;
  Map<String,int> _counter ={};
  bool forceRefresh=false;

  Future< List<MaTransaction>> init() async {
    if(!forceRefresh && hasTransactions) return Transactions;
    var __transactions=  await MATransactionsController.getAlltransactions();
    _transactions=(__transactions);
   
    // for (var element in _transactions) {
    //    debugPrint('----------------------------------------transaction');
    //    debugPrint('${element}');
    // }
    // debugPrint('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize size ${_transactions.length}');
    return Transactions;
  }
  Future< Map<String,int>> countByStatus() async {
    _counter ={};
    var _transactions=  await init();
    for (var element in _transactions) {
       debugPrint('-----transID: ${element.id} transStatus ${element.status?.keyValue}-----');
       debugPrint('${element}');
       String _status= element.status?.keyValue ?? 'unknown';
       int value= 1;
      
      if(_counter.containsKey(_status )){
          value+= _counter[_status] ?? 0;
      }else{
        
      }
        _counter.addIf(true,_status, value);
    }
    print(_counter);
    return _counter;
  }

  List<ChipReportItem>  get statusReport{
      return  MaStatusConfig.statusConfig0.entries.map((e) { 
          return ChipReportItem(status: e.value, value: _counter.putIfAbsent(e.key, () => 0));
          }
      ).toList();
  }




}
class ChipReportItem {
    final MaStatusConfig status;
    final int value;

  ChipReportItem({required this.status, required this.value});
  @override
  toString(){
    return ':: ChipReportItem >> (value: value ,status: ${status.toString()})';
  }
}
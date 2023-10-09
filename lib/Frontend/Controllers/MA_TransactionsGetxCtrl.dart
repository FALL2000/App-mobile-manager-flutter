// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_TransactionsController.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/model/MA_Request.dart';

class TransactionsProvider extends GetxController{
  List<MaTransaction> _transactions=[];
  List<MaTransaction> _filterTransactions=[];
  bool get hasTransactions => _transactions.isNotEmpty;
  int pageSize = 10;
  String searchText='';
  List<MaTransaction> get Transactions => _transactions;
  set Transactions ( List<MaTransaction> Transactions){
    _transactions = Transactions;
    // notifyListeners();
  }
  List<MaTransaction> getTransactions() {
    return Transactions.map((e) => e).toList();
  }

  
  // Future<bool> saveTransaction(MaTransaction? request) async{
  //   if(request==null) return false;
  //   request.status=RequestStatus.open;
  //   String respond= await MATransactionsController.saveTransfert(request) ?? '';
  //   return respond.isEmpty ? false : true;
  // }  
  // Future<bool> updateTransaction(MaTransaction? request) async{
  //   if(request==null) return false;
  //   return await MATransactionsController.updateTransfert(request,request.id);
  // }
  Future< List<MaTransaction>> init() async {
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize hasTransactions== $hasTransactions');
    // return [];
    if(hasTransactions) return Transactions;  // to uncomment in order to alw\ays  have refreshed data
    var __transactions=  await MATransactionsController.getAlltransactions();
    _transactions.addAll(__transactions);
    _transactions.addAll(__transactions);
    _transactions.addAll(__transactions);
    _transactions.addAll(__transactions);
    print(_transactions);
    /*
        await Future.delayed(const Duration(seconds: 2));
        _transactions=  await MaMockRepository.generatesTransactions(30);
    */
     print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize size ${_transactions.length}');
    return Transactions;
  }
  List<MaTransaction> filter()  {
    var txt= (searchText??'').toLowerCase();
     print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: filter txt `${txt}`  ');
    _filterTransactions=  _transactions.where((trans){
      

      var find= trans.amount.toLowerCase().contains(txt) /*|| trans.from.toLowerCase().contains(txt)*/ || trans.to.toLowerCase().contains(txt);
      return find;
    }).toList();

     print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize size ${_transactions.length}');
    return Transactions;
  }

  Future< List<MaTransaction>> getNextPageData(int page) async {
    if(page==0) await init();
    filter();
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@start TransactionsProvider ::::: getNextPageData $page ');
    await Future.delayed(const Duration(seconds: 1));
    int start = min(max(((page) * pageSize),0),_filterTransactions.length) ;
    int end = min( ((page + 1)  * pageSize), _filterTransactions.length ) ;

    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@TransactionsProvider ::::: getNextPageData start: $start - end: $end');
    final items = _filterTransactions.sublist(start, end) ;
    return items;
  }
  
  
}
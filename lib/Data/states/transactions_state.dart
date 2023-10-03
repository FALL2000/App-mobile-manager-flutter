// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_TransactionsController.dart';
import 'package:x_money_manager/model/MA_MockRepository.dart';
import 'package:x_money_manager/model/MA_Request.dart';

class TransactionsProvider extends ChangeNotifier{
  List<MaRequest> _transactions=[];
  List<MaRequest> _filterTransactions=[];
  bool get hasTransactions => _transactions.isNotEmpty;
  int pageSize = 20;
  String searchText='';
  List<MaRequest> get Transactions => _transactions;
  set Transactions ( List<MaRequest> Transactions){
    _transactions = Transactions;
    notifyListeners();
  }
  List<MaRequest> getTransactions() {
    return Transactions.map((e) => e).toList();
  }

  
  // Future<bool> saveTransaction(MaRequest? request) async{
  //   if(request==null) return false;
  //   request.status=RequestStatus.open;
  //   String respond= await MATransactionsController.saveTransfert(request) ?? '';
  //   return respond.isEmpty ? false : true;
  // }  
  // Future<bool> updateTransaction(MaRequest? request) async{
  //   if(request==null) return false;
  //   return await MATransactionsController.updateTransfert(request,request.id);
  // }
  Future< List<MaRequest>> init() async {
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize hasTransactions== $hasTransactions');
    // return [];
    // if(hasTransactions) return Transactions;  // to uncomment in order to alw\ays  have refreshed data
    _transactions= await MATransactionsController.getAlltransferts();
    print(_transactions);
    /*
        await Future.delayed(const Duration(seconds: 2));
        _transactions=  await MaMockRepository.generatesTransactions(30);
    */
     print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize size ${_transactions.length}');
    return Transactions;
  }
  List<MaRequest> filter()  {
    var txt= (searchText??'').toLowerCase();
     print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: filter txt `${txt}`  ');
    _filterTransactions=  _transactions.where((trans){
      

      var find= trans.amount.toLowerCase().contains(txt) /*|| trans.from.toLowerCase().contains(txt)*/ || trans.to.toLowerCase().contains(txt);
      return find;
    }).toList();

     print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize size ${_transactions.length}');
    return Transactions;
  }

  Future< List<MaRequest>> getNextPageData(int page) async {
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
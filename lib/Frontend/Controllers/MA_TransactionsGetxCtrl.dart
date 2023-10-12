// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_TransactionsController.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';

class TransactionsProvider extends GetxController{
  List<MaTransaction> _transactions=[];
  RxSet<String> statusFiltered=<String>{}.obs;
  bool refreshList=false;
  int pageSize = 10;
  String searchText='';
  List<MaTransaction> _filterTransactions=[];
  // bool starting=false;
  // RxBool  searching=false.obs;
  // bool started=false;
  
  bool get hasTransactions => _transactions.isNotEmpty;
  List<MaTransaction> get Transactions => _transactions;


  set Transactions ( List<MaTransaction> Transactions){
    _transactions = Transactions;
  }
  
  List<MaTransaction> getTransactions() {
    return Transactions.map((e) => e).toList();
  }

  void updateSearchTerm(String _searchTerm){
    searchText=_searchTerm;
    refreshList=true;
    update();
  }
  void updateStatusSet(String _status,{bool remove=false}){
    if(remove==true){
      statusFiltered.remove(_status);
    }else{
      statusFiltered.add(_status);
    }
    
    refreshList=true;
    update();
  }
  void initFilter(){
    statusFiltered=<String>{}.obs;
    searchText='';
    _filterTransactions= _transactions;
    // update();
  }
  Future<void> triggerRebuild()async{
    update(); 
  }
  Future< List<MaTransaction>> init() async {
    debugPrint('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize hasTransactions== $hasTransactions');
    if(hasTransactions) return Transactions;  // to uncomment in order to alw\ays  have refreshed data
    var __transactions=  await MATransactionsController.getAlltransactions();
    _transactions=(__transactions);
    // _transactions.addAll(__transactions);
    // _transactions.addAll(__transactions);
    // _transactions.addAll(__transactions);
    // _transactions.addAll(__transactions);
    // _transactions.addAll(__transactions);
    // _transactions.addAll(__transactions);
   
    for (var element in _transactions) {
       debugPrint('----------------------------------------transaction');
       debugPrint('${element}');
    }
    debugPrint('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize size ${_transactions.length}');
    return Transactions;
  }
  void filter()  {
      var txt= (searchText??'').toLowerCase();
      debugPrint('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: filter txt `${txt}`  ');
      if(statusFiltered.isEmpty && txt.isEmpty)  _filterTransactions= _transactions;
      if(statusFiltered.isNotEmpty){
        //status filter mode
        _filterTransactions= _transactions.where((trans){
            var st=trans.status?.keyValue.toUpperCase();
            var find= statusFiltered.contains(st);
            debugPrint('found $find status: $st statuses: ${statusFiltered.toString()}');
            return find;
            }).toList();
      }else{
        //text mode
        _filterTransactions= _transactions.where((trans){
              var find= trans.amount.toLowerCase().contains(txt) || trans.id.toLowerCase().contains(txt) || trans.from.toLowerCase().contains(txt) || trans.to.toLowerCase().contains(txt);
              return find ;
            }).toList();
      }
    

     debugPrint('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TransactionsProvider ::::: initialize size ${_transactions.length}');
    // return Transactions;
  }

  Future< List<MaTransaction>> getNextPageData(int page) async {
    if(isInitable(page: 0)) await init();
    filter();
    if(_filterTransactions.isEmpty) return [];
    //debugPrint('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@start TransactionsProvider ::::: getNextPageData $page ');
    await Future.delayed(const Duration(milliseconds: 500));//mockdelay
    int start = min(max(((page) * pageSize),0),_filterTransactions.length) ;
    int end = min( ((page + 1)  * pageSize), _filterTransactions.length ) ;
    debugPrint('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@TransactionsProvider ::::: getNextPageData ->page $page start: $start - end: $end');
    final items = _filterTransactions.sublist(start, end) ;
    return items;
  }

  bool isInitable({required int page}){

    return page==0;
  }

  
  
}
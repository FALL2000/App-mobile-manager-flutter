import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_TransactionsController.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';

class MaTransactionDetailsProvider extends GetxController{

  MaTransaction? transaction;
  bool inAgentRefreshed=false;
  bool outAgentRefreshed=false;
  updateInAgent(agent){
    transaction?.InZoneAgent=agent;
    inAgentRefreshed=true;
    update();
  }
  updateOutAgent(agent){
    transaction?.outZoneAgent=agent;
    outAgentRefreshed=true;
    update();
  }
  updateAgent(agent, ZoneId){
    if(ZoneId==transaction?.inCountry?.id){
      updateInAgent(agent);
    }else{
      updateOutAgent(agent);
    }
  }

  Future<void> doRefresh() async {
    MaTransaction? _trans=await  MATransactionsController.getTransactionDetails(transaction?.id);
    if(_trans!=null) {
      transaction= _trans;
      update();
    }
  }




}
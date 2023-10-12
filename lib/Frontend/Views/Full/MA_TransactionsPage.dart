import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_TransactionsList.dart';
    
class MaTransactionsPage extends StatelessWidget {

  const MaTransactionsPage({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body:  MaTransactionsList(),
    );
  }
}
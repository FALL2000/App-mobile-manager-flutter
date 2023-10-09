import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_List.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_TransactionsList.dart';
    
class MaTransactionsPage extends StatelessWidget {

  const MaTransactionsPage({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  MaTransactionsList( ),
    );
  }

  Future<List<String>> getNextPageData(int page) async {
    await Future.delayed(const Duration(seconds: 2));
    if (page == 3) return [];
    final items = List<String>.generate(14, (i) => "Item $i Page $page");
    return items;
  }
}
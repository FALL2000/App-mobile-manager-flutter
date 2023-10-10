import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionsGetxCtrl.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:x_money_manager/Utilities/widgets/inputs.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_TransactionsList.dart';

    
class MATransactionSearchPage extends StatefulWidget {

  MATransactionSearchPage({ Key? key }) : super(key: key);
  @override
  State<MATransactionSearchPage> createState() => _MASearchPageState();
}

class _MASearchPageState extends State<MATransactionSearchPage> {
  final controller = Get.put(TransactionsProvider());
  final TextEditingController searchCtrl= TextEditingController();
  String searchText='';
  bool viewSearchResult=false;
  final _focusNode = FocusNode();
  doSearch(){
      controller.searchText=searchText;
  }
  @override
  Widget build(BuildContext context) {
    searchCtrl.text = searchText;
    print('buidint with search text $searchText');
    var timer ;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: !viewSearchResult,
          controller: searchCtrl,
            // focusNode: primaryFocus,
            focusNode: _focusNode,
            onChanged: (value){
              timer?.cancel();
               timer = Timer(Duration(seconds: 1), () {
                  setState(() {
                    viewSearchResult =true;
                    _focusNode.unfocus();
                    searchText = value;
                    doSearch();
                  });

               });
            },
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: 'Search',
            ),
            ),
        actions: <Widget>[
        
        Visibility(
          visible: searchText.isNotEmpty,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              semanticLabel: 'close', // New code
            ),
            onPressed: () {
              
             setState(() {
                  viewSearchResult =true;
                      _focusNode.unfocus();
                      searchText = '';
                      doSearch();
                });
            },
          ),
        ),
      ],
      ),
      body: Visibility(
            visible: viewSearchResult,
            child:  MaTransactionsList(forceRefresh:true) 
          ),
    );
  }
}
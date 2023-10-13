import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionsGetxCtrl.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_TransactionsList.dart';

    
class MATransactionSearchPage extends StatelessWidget{
  final controller = Get.put(TransactionsProvider());
  MATransactionSearchPage({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(

             onWillPop: () {
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                print('poping context........ ');
                controller.initFilter();//clear filter
                Navigator.pushReplacementNamed(context,'/Transactions');
                return Future.value(false);
             },

             child: MATransactionSearchPage0(),
          );
  }
}
class MATransactionSearchPage0 extends StatefulWidget {

  const MATransactionSearchPage0({ Key? key }) : super(key: key);
  @override
  State<MATransactionSearchPage0> createState() => _MASearchPageState();
}

class _MASearchPageState extends State<MATransactionSearchPage0> {
  final controller = Get.put(TransactionsProvider());
  final TextEditingController searchCtrl= TextEditingController();
  String searchText='';
  bool viewSearchResult=false;
  final _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
     controller.initFilter();
  }
  /*@override
  void dispose() {
    super.dispose();
    controller.initFilter();
  }*/
  doSearch(){
      controller.updateSearchTerm(searchText);
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
            child:  MaTransactionsList() 
          ),
    );
  }
}
class MATransactionSearchIcon extends StatelessWidget {

  const MATransactionSearchIcon({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MATransactionSearchPage()),
              );
            },
          );
  }
}
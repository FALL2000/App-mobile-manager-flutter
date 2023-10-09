import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionsGetxCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/statusIconWidget.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
// import './statusIconWidget.dart';
class MaTransactionsList extends StatefulWidget {
  const MaTransactionsList({Key? key}) : super(key: key);

  @override
  _MaTransactionsListState createState() => _MaTransactionsListState();
}

class _MaTransactionsListState extends State<MaTransactionsList> {
  final controller = Get.put(TransactionsProvider());
  // int pageSize= controller.pageSize;
  Future<List<MaTransaction>> getNextPageData(int page) async {
    var items= await controller.getNextPageData(page);
    everyThingLoaded=  items.length < controller.pageSize;
    return items;
  }

  List<MaTransaction> data = [];
  bool everyThingLoaded = false;

  @override
  void initState() {
    super.initState();

    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
   
    return  RefreshIndicator(
          onRefresh: () async {
            await loadInitialData();
          },
          child: InfiniteScrollList(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: data.map((e) => TransactionItem(transaction: e)).toList(),
              onLoadingStart: (page) async {
                List<MaTransaction> newData = await getNextPageData(page);
                setState(() {
                  data += newData;
                  if (newData.isEmpty || newData.length < controller.pageSize) {
                    everyThingLoaded = true;
                  }
                });
              },
              everythingLoaded: everyThingLoaded,
          ),
    );
  }

  Future<void> loadInitialData() async {
    data = await getNextPageData(0);
    setState(() {});
  }
}

class ListItem extends StatelessWidget {
  final String text;
  const ListItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.image),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final MaTransaction transaction;
  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  goToDetails(context){
    // Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (BuildContext context) => TransactionDetailsPage(transactionId: transaction.id,)),
    //         );
  }
  @override
  Widget build(BuildContext context) {
    // print('transaction ${transaction.toString()}');
    return Dismissible(
      key: Key(transaction.code),
      child: Container(
        
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          print('width >>>> ${constraints.biggest.width} ');
          List<Widget> headers=[
            TextButton(
                        child:Text(transaction.code),
                        onPressed: (){
                          goToDetails(context);
                        },
                        ),
                      Expanded(child: Text('${transaction.formattedDate}',textAlign: TextAlign.right,),),
          ];

          if(transaction.status!.isInProggress )
          {
            headers.add(
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child: Badge( 
                      backgroundColor: /*Theme.of(context).colorScheme.secondary*/Colors.green, 
                      smallSize: 15.5,),
                ),
            );
          }
           
          // if(constraints.biggest.width > 100 ) {
          //  } else return SizedBox(width: 10,)  ;
           return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //child: Row(
                children: [
                  Row(
                    children: headers,
                  ),
                  ListTile(
                    onTap: () {
                        print('on pressed  ${transaction.code}');
                        goToDetails(context);
                    },
                        title: Text(
                          transaction.formattedamount,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        subtitle: Text(transaction.to) ,
                        trailing: statusIconWidget(status: transaction.status?.keyValue),
                      ),
                ],
            // ),
            );
          
        }
        )
      ),
    );
  }
}
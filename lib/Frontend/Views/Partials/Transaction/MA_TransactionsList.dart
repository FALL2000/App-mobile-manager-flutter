import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionsGetxCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_StatusIconWidget.dart';
import 'package:x_money_manager/Utilities/widgets/MA_InifiniteScrollList.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Utilities/MA_TransactionUtils.dart';
// import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';

class MaTransactionsList extends StatelessWidget {
  MaTransactionsList({Key? key}) : super(key: key);
  final controller = Get.put(TransactionsProvider());//required for init get builder

  
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<TransactionsProvider>(builder: (_){
      return  MaTransactionsList0();
    });
  }
}
class MaTransactionsList0 extends StatefulWidget {
  MaTransactionsList0({Key? key}) : super(key: key);
  @override
  _MaTransactionsListState createState() => _MaTransactionsListState();
}

class _MaTransactionsListState extends State<MaTransactionsList0> {
  final controller = Get.put(TransactionsProvider());
  bool isLoading=true;
  List<MaTransaction> data = [];
  bool everyThingLoaded = false;
  

  get hasData => !isLoading && data.isNotEmpty;
  get noData => !isLoading && data.isEmpty;
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }
  @override
  void didUpdateWidget(covariant MaTransactionsList0 oldWidget) { 
    super.didUpdateWidget(oldWidget); 
    if(controller.refreshList) { 
      controller.refreshList=false;
      isLoading=true; 
      loadInitialData();
    }
  }

  Future<void> loadInitialData() async {
    data = await getNextPageData(0);
    isLoading=false;
    setState(() {});
  }
  Future<List<MaTransaction>> getNextPageData(int page) async {
    isLoading=true;
    var items= await controller.getNextPageData(page);
    everyThingLoaded=  items.length < controller.pageSize; 
    return items;
  }
  @override
  Widget build(BuildContext context) {
    debugPrint('building MaTransactionsList with : \n showFilterBadges ${ controller.statusFiltered.isNotEmpty} \n everyThingLoaded: $everyThingLoaded   \n isloading: $isLoading \n data.size: ${data.length} ');
    
    return  Column(
              children: [
                Visibility(
                    visible:  controller.statusFiltered.isNotEmpty,
                    child:  MAStatusesBadges(controller: controller)
                ),
                Visibility(
                  visible:  isLoading || hasData,
                  child: Expanded(
                    child: MaInfiniteScrollList(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        onRefresh: () async { 
                          controller.initFilter();
                          await loadInitialData();
                        },
                        onLoadingStart: (page) async {
                          debugPrint('onLoadingStart...');
                          List<MaTransaction> newData = await getNextPageData(page);
                          setState(() {
                            // isLoading=false;
                            data += newData;
                            if (newData.isEmpty || newData.length < controller.pageSize) {
                              everyThingLoaded = true;
                            }
                          });
                        },
                        everythingLoaded: everyThingLoaded,
                        children: data.map((e) => TransactionItem(transaction: e)).toList(),
                      ),
                  ),
                ),
                Visibility(
                  visible: noData,
                  child: 
                  Expanded(
                    child: RefreshIndicator.adaptive(
                      onRefresh: () async {
                        await loadInitialData();
                      },
                      child:  Center(
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: const Text('Nothing to display')
                        )
                      ),
                    ),
                  )
                ),
                // Visibility(
                //   visible: isLoading,
                //   child: Center(
                //     child:MaSpinner())
                //   )
              ],
            );
  }
}

class MAStatusesBadges extends StatelessWidget {
  const MAStatusesBadges({
    super.key,
    required this.controller,
  });

  final TransactionsProvider controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      height: 30,
      child: ListView(
        reverse: true,
        scrollDirection : Axis.horizontal,
        children: controller.statusFiltered.map((element) {
              MaStatusConfig? icn=MaStatusConfig.statusConfig0[element];
              return  Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                
                child: Dismissible(
                  direction : DismissDirection.vertical,
                  onDismissed: (dir){
                    controller.updateStatusSet(element,remove:true);
                  },
                  key: Key(icn?.key ?? '-') ,
                  child: Badge(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    label: Text( icn!.label),
                    backgroundColor: icn.color,// ?? Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ) ;
            } 
            ).toList(),
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
    
  }
  @override
  Widget build(BuildContext context) {
   
    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          //debugPrint('width >>>> ${constraints.biggest.width} ');
          List<Widget> headers=[
            TextButton(
              child:Text(transaction.code),
              onPressed: (){
                goToDetails(context);
              },
            ),
            Expanded(
              child: Text('${transaction.formattedDate}',
                            textAlign: TextAlign.right,
              ),
            ),
          ];

          if(transaction.status!.isInProggress )
          {
            // headers.add(
            //     // Padding(
            //     //   padding: const EdgeInsets.only(left: 5,right: 5),
            //     //   child: Badge( 
            //     //       backgroundColor: /*Theme.of(context).colorScheme.secondary*/Colors.green, 
            //     //       smallSize: 15.5,),
            //     // ),
            // );
          }
           return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: headers,),
                ListTile(
                  onTap: () {
                      goToDetails(context);
                  },
                  title: Text(
                    transaction.formattedamount,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  subtitle:Column(
                    crossAxisAlignment : CrossAxisAlignment.start,
                    children: [
                      Text('${transaction.from} - ${transaction.to}'),
                      Badge(
                        label: Text('${transaction.participants} participants'),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      )
                    ],
                  ) ,
                  trailing: MAStatusIconWidget(status: transaction.status?.keyValue),
                ),
              ],
            );
        }
      )
    );
  }
}


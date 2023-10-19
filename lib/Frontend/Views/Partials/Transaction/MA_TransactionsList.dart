import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionsGetxCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_TransactionItem.dart';
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
                        children: data.map((e) => MaTransactionItem(transaction: e)).toList(),
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
      height: 40,
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
                  child:/*FilterChip(
                          label: Text(icn!.label, style:  TextStyle(color: AppBarTheme.of(context).foregroundColor),),
                          selected: true,
                          onSelected: (bool selected) {
                             controller.updateStatusSet(element,remove:true);
                          },
                        )*/
                  
                   Chip(
                          elevation: 0.9,
                          backgroundColor:  icn?.color,
                          labelPadding: const EdgeInsets.symmetric(vertical: 2),
                          label:  Text(icn!.label, style:  TextStyle(color: AppBarTheme.of(context).foregroundColor),),
                          deleteIcon:const  Icon(Icons.close),
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            controller.updateStatusSet(element,remove:true);
                          },
                        )
                  
                  /*Badge(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    label: Text( icn!.label),
                    backgroundColor: icn.color,// ?? Theme.of(context).colorScheme.tertiary,
                  ),*/
                ),
              ) ;
            } 
            ).toList(),
      ),
    );
  }
}





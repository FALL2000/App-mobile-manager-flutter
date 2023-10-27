import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Backend/MA_TransactionsController.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionDetailsGetXCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Error.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/MA_InZoneTab.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/MA_detailsTab.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_outZoneTab.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
    
class MaTransactionDetailsPage extends StatelessWidget {
  
  MaTransactionDetailsPage({ Key? key, required this.requestId, this.from }) : super(key: key);
  final String requestId;
  final String? from;
  @override
  Widget build(BuildContext context) {
    // final MaTransactionDetailsProvider controller = Get.put(MaTransactionDetailsProvider());
    return WillPopScope(

             onWillPop: () {
              if(from!=null) return Future.value(true);
              // while (Navigator.canPop(context)) {
              //   Navigator.pop(context);
              // }
              try{
                Navigator.popUntil(context, ModalRoute.withName('/Transactions'));
                Navigator.pushReplacementNamed(context,'/Transactions');
              }catch(e){
                Navigator.pushReplacementNamed(context,'/Transactions');
              }
              

              return Future.value(false);
             },

             child: FutureBuilder<MaTransaction?>(
                    future: MATransactionsController.getTransactionDetails(requestId), // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<MaTransaction?> snapshot) {
                      Widget child;
                      if (snapshot.hasData) {
                        child = GetBuilder<MaTransactionDetailsProvider>(
                          init: MaTransactionDetailsProvider(),
                          builder: (controller){
                              controller.transaction=snapshot.data;

                              debugPrint(' controller inAgentRefreshed ${controller.inAgentRefreshed}');
                              debugPrint(' controller outAgentRefreshed ${controller.outAgentRefreshed}');
                              return  _detailsView();
                            });
                        
                         
                      } else if (snapshot.hasError) {
                        child = Scaffold(body:MaError(snapshot: snapshot ,));
                      } else {
                        child = Scaffold(body: MaSpinner());
                      }
                      return child;
                    },
                  )
          );
  }
}
enum SampleItem { Export, Report }
class _detailsView extends StatelessWidget {
   _detailsView({
    super.key,  
    //this.request
  });
  MaTransaction? request;
  final MaTransactionDetailsProvider controller = Get.find();
  bool refreshed01=false;
  bool refreshed02=false;
  @override
  Widget build(BuildContext context) {
    final actionsBar=<Widget>[];

    
    request= controller.transaction;
    var zone1= '${ request?.inCountry!.name ?? 'In Zone'}';
    var zone2= '${ request?.outCountry!.name ?? 'Out Zone'}';
    actionsBar.add(
       PopupMenuButton<SampleItem>(
        surfaceTintColor: Colors.black12,
        offset: Offset(0, 60),
        color: Colors.white,
        // initialValue: selectedMenu,
        // Callback that sets the selected popup menu item.
        onSelected: (SampleItem item) {
          debugPrint('selectedMenu $item');
          // setState(() {
          //   // selectedMenu = item;
          // });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
          const PopupMenuItem<SampleItem>(
            value: SampleItem.Export,
            child: ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('Export')
              ),
          ),
           const PopupMenuItem<SampleItem>(
            value: SampleItem.Report,
            child: ListTile(
              leading: Icon(Icons.report), 
              title: Text('Report')),
          ),
        ],
        ),
    ); 
     print('------Details of ${request.toString()}');
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          
          title: Text('${request?.id}'),
          actions: actionsBar,
          bottom:  TabBar(
            // isScrollable: true,
            labelColor: AppBarTheme.of(context).foregroundColor,
            tabs: <Widget>[
                const Tab(
                text:'Details',
                // icon:Icon(Icons.details) ,
              ),
              Tab(
                text: zone1,
                icon:request!.hasInAgent ?  null :Icon(Icons.error) ,
              ),
              Tab(
                text: zone2,
                icon:request!.hasOutAgent ?  null :Icon(Icons.error) ,
              ),
            ],
          ),
        ),
        body: TabBarView(
            children: <Widget>[
              MaDetailsTab(),
              MaInZoneTab(),
              MaOutZoneTab(),
            ],
        ),
      ),
    );
  }
}



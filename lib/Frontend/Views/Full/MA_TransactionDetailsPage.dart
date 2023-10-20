import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_TransactionsController.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Error.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/MA_InZoneTab.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/MA_detailsTab.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_outZoneTab.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
    
class MaTransactionDetailsPage extends StatelessWidget {

  const MaTransactionDetailsPage({ Key? key, required this.requestId }) : super(key: key);
  final String requestId;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(

             onWillPop: () {
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushReplacementNamed(context,'/Transactions');

                return Future.value(false);
             },

             child: FutureBuilder<MaTransaction?>(
                    future: MATransactionsController.getTransactionDetails(requestId), // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<MaTransaction?> snapshot) {
                      Widget child;
                      if (snapshot.hasData) {
                        child = _detailsView(request: snapshot.data);
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

class _detailsView extends StatefulWidget {
   _detailsView({
    super.key,  this.request
  });
  MaTransaction? request;

  @override
  State<_detailsView> createState() => _detailsViewState();
}

class _detailsViewState extends State<_detailsView> {
  bool refreshed01=false;
  bool refreshed02=false;
  @override
  Widget build(BuildContext context) {
    var zone1= '${ widget.request?.inCountry!.name ?? 'In Zone'}';
    var zone2= '${ widget.request?.outCountry!.name ?? 'Out Zone'}';

     print('------Details of ${widget.request.toString()}');
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          
          title: Text('${widget.request?.id}'),
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
                icon:widget.request!.hasInAgent ?  null :Icon(Icons.error) ,
              ),
              Tab(
                text: zone2,
                icon:widget.request!.hasOutAgent ?  null :Icon(Icons.error) ,
              ),
            ],
          ),
        ),
        body:  TabBarView(
          children: <Widget>[
            MaDetailsTab(request: widget.request),
            MaInZoneTab(transaction: widget.request,
                refreshed: refreshed01,
                onAgentRefresh:(agent){
                    widget.request?.InZoneAgent=agent;
                    setState(() {
                      refreshed01=true;
                    });
                }),
            MaOutZoneTab(transaction: widget.request,
                refreshed: refreshed02,
                onAgentRefresh:(agent){
                  print('refreshed agent');
                    widget.request?.outZoneAgent=agent;
                    setState(() {
                      refreshed02=true;
                    });
                }
            ),
          ],
        ),
      ),
    );
  }
}



class _outZoneTab extends StatelessWidget {
  const _outZoneTab({
    super.key,
    required this.request,
  });

  final MaTransaction? request;

  @override
  Widget build(BuildContext context) {
    return Text('------Details of ${request?.outCountry.toString()}  ${request?.outZoneDetails.toString()}');
  }
}


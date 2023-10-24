
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Backend/MA_TransactionsController.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionDetailsGetXCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneAgentItem.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneApprovalItem.dart';
import 'package:x_money_manager/Model/MA_Response.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';
import 'package:x_money_manager/Utilities/utils.dart';
import 'package:x_money_manager/Utilities/widgets/outputs.dart';
    



    

class MaZoneDetailsWidget extends StatefulWidget {
   MaZoneDetailsWidget({
    super.key,
    required this.approvals,
    required this.zoneId,
    required this.transactionId,
    this.agent,
    this.gap,
    required this.refreshed,
  });
  List<approvalTransaction> approvals;
   MaUser? agent;
  final String zoneId;
  final String transactionId;
  final gapInfo? gap;
  bool refreshed=false;

  @override
  State<MaZoneDetailsWidget> createState() => _MaZoneDetailsWidgetState();
}

class _MaZoneDetailsWidgetState extends State<MaZoneDetailsWidget> {
  get hasAgent => widget.agent!=null;

  get hasGap=> widget.gap!= null;

  MaResponse? _response;
  bool _isLoading=false;
  final MaTransactionDetailsProvider controller = Get.find();


  Future<void> handleAgentSelected(String agentId) async{
    debugPrint('Selected agentId $agentId');
    List<String> approvalsIds = widget.approvals.map((app){
          return app.id ?? '';
    }).toList() ?? [];
    debugPrint('Selected agentId $agentId     approvalsIds $approvalsIds');
    _response=await MATransactionsController.getAssignAgent(agentId,widget.transactionId, approvalsIds);
    debugPrint(' approvalsIds ${this.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    final widgets=<Widget>[
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // children: actions,
        ),
        
    ];
    var wd= (hasAgent )? MaZoneAgentItem(agent: widget.agent , refreshed: widget.refreshed,
                                          onAgentRefresh:(agent){
                                            controller.updateAgent(agent, widget.zoneId, );
                                          }) 
                        : MissingMaZoneAgentItem(
                                    zoneId: widget.zoneId,
                                    onAgentSelected: (agent) async{
                                       setState(() {
                                         _isLoading=true;
                                       });
                                        await handleAgentSelected(agent.userId ?? '');
                                         
                                        if(_response!.error){
                                          setState(() {
                                            _isLoading=false;
                                          });
                                          maShowSnackBar(context:context,message: _response!.message,error: true);
                                        }
                                        else{
                                          debugPrint('-------------------------------------------------------- refreshpage ${widget.key.toString()}');
                                          controller.updateAgent(agent, widget.zoneId, );
                                          setState(() {
                                            _isLoading=false;
                                          });
                                        }
                                        
                                    },
                            );
    widgets.add( wd);
    
    if(hasGap){
      widgets.add(
          outputField(
              leading_icon: MaIcons.AMOUNT,
              label:'Gap:', value: widget.gap?.formattedamount?? '',
              hide_border: true,
          ),);
    }
    List<Widget> list= widget.approvals.map((app){
      debugPrint('App ... ${app.toString()}');
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: MaZoneApprovalItem(approval: app,),
            );
        }).toList() ?? [];
    widgets.add(
      const Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Text('Participants',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
    );
    widgets.add(
        
        Expanded(
          child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: list,
              ),
        )
     );
     
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async{
            debugPrint('RefreshIndicator----start');
            await controller.doRefresh(); 
            debugPrint('RefreshIndicator----End');
          },
          child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgets,
                ),
        ),
        Visibility(
          visible: _isLoading,
          child: MaSpinner(title: 'Please Wait...',)
        
        )
        ],
    );
    
   
  }
}



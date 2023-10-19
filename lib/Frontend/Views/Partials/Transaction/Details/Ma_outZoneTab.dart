
import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/MA_ZoneDetailsWidget.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneAgentItem.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneApprovalItem.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';
import 'package:x_money_manager/Utilities/widgets/outputs.dart';
    

class MaOutZoneTab extends StatelessWidget {
   MaOutZoneTab({
    super.key,
    required this.transaction,
    required this.onAgentRefresh,
    required this.refreshed,
  });
  bool refreshed=false;

  final MaTransaction? transaction;
  final ValueChanged<MaUser?> onAgentRefresh;
  var refreshed01=false;
  @override
  Widget build(BuildContext context) {
    return MaZoneDetailsWidget(
      key: const Key('2'),
      transactionId: transaction?.id,
      approvals: transaction?.outZoneDetails ?? [], 
      zoneId: transaction!.outCountry?.id ?? '',
      agent: transaction?.outZoneAgent,
      gap: transaction?.gap,
      refreshed: refreshed,
      onAgentRefresh:(agent){
          transaction?.outZoneAgent=agent;
          this.onAgentRefresh(agent);
      }
      
      );
    /*
    final widgets=<Widget>[
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // children: actions,
        ),
        
    ];
    var wd= (transaction!.hasOutAgent )? MaZoneAgentItem(agent: transaction!.outZoneAgent ,
              refreshed: refreshed01,
              onAgentRefresh:(agent){
                  transaction?.outZoneAgent=agent;
                  refreshed01=true;
              }
    ) :  MissingMaZoneAgentItem(
                                    zoneId: transaction!.outCountry?.id ?? '',
                                    onAgentSelected: (agentId){
                                        debugPrint('Selected agentId $agentId');
                                        List<String> approvalsIds = transaction?.outZoneDetails.map((app){
                                              return app.id ?? '';
                                        }).toList() ?? [];
                                        debugPrint('Selected agentId $agentId     approvalsIds $approvalsIds');
                                    },
    );
    widgets.add( wd);
    bool hasGap= transaction?.gap != null;
    if(hasGap){
      widgets.add(
          outputField(
              leading_icon: MaIcons.AMOUNT,
              label:'Gap:', value: transaction?.formattedgap ?? '',
              hide_border: true,
          ),);
    }
    List<Widget> list= transaction?.outZoneDetails.map((app){
            return Padding(
              padding: const EdgeInsets.only(left: 40),
              child: MaZoneApprovalItem(approval: app,),
            );
        }).toList() ?? [];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text('Participants'),
      )
    );
    widgets.addAll(
        list
     );
     
    return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: widgets,
            );
    
   */
  }
}

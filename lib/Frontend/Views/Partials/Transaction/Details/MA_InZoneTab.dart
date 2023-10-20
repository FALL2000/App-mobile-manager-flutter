import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/MA_ZoneDetailsWidget.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneAgentItem.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneApprovalItem.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Model/MA_User.dart';
    

class MaInZoneTab extends StatelessWidget {
  MaInZoneTab({
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
      key: const Key('1'),
      transactionId: transaction?.id,
      approvals: transaction?.InZoneDetails ?? [], 
      zoneId: transaction!.inCountry?.id ?? '',
      agent: transaction?.InZoneAgent,
      refreshed: refreshed,
      onAgentRefresh:(agent){
          transaction?.InZoneAgent=agent;
          this.onAgentRefresh(agent);
      }
      // gap: transaction?.gap,
      
      );
    /*final widgets=<Widget>[
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // children: actions,
        ),
        
    ];
    var wd= (transaction!.hasInAgent )? MaZoneAgentItem(agent: transaction!.InZoneAgent ,
                                                        refreshed: refreshed01,
                                                        onAgentRefresh:(agent){
                                                            transaction?.InZoneAgent=agent;
                                                            refreshed01=true;
                                                        }
                                        ) :  MissingMaZoneAgentItem(
                                    zoneId: transaction!.inCountry?.id ?? '',
                                    onAgentSelected: (agentId){
                                        debugPrint('Selected agentId $agentId');
                                    },
    );
    widgets.add( wd);
    List<Widget> list= transaction?.InZoneDetails.map((app){
            return Padding(
              padding: const EdgeInsets.only(left: 25),
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

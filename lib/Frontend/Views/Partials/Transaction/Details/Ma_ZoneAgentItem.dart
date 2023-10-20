import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Backend/MA_UserController.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionDetailsGetXCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Error.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Utilities/widgets/MA_CardLoader.dart';
import 'package:x_money_manager/Utilities/widgets/outputs.dart';
    

class _MaZoneAgentItem extends StatelessWidget {
  const _MaZoneAgentItem({
    super.key,
    required this.agent,
  });

  final MaUser? agent;

  @override
  Widget build(BuildContext context) {
    
    return _agentCard(
            child: ExpansionTile(
            // collapsedShape:const  Border( 
            //   top: BorderSide(color: Colors.transparent , width: 0) ,
            //   bottom: BorderSide( color: Colors.red ,width: 5) ,
            // ),
            shape:  const Border( 
              top:  BorderSide(color: Colors.transparent , width: 0) ,
              bottom:  BorderSide(color: Colors.transparent , width: 0) ,
            ),
                leading: CircleAvatar( child: Text('${agent?.initial}'),),
                title: Text('${agent?.fullname}') ,
                subtitle: Text('Agent In charge') ,
                children: [
                outputField(value: '${agent?.phone}', label: 'Phone', hide_border: true,),
                outputField(value: '${agent?.email}', label: 'Email', hide_border: true,),
            ],
            ),
          );
    
   
  }
}

class _agentCard extends StatelessWidget {
  const _agentCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: child,
    );
  }
}



class MaZoneAgentItem extends StatelessWidget {
   MaZoneAgentItem({
    super.key,
    required this.agent,
    required this.onAgentRefresh,
    required this.refreshed,
  });

  final MaUser? agent;
  final bool refreshed;
  final ValueChanged<MaUser?> onAgentRefresh;
  MaUser? _agent;
  bool loaded=false;
  Future<void> getAgentData() async{
      _agent = await MaUserController.getUserInfo(agent?.userId ?? '');
      onAgentRefresh(_agent);
  }
  @override
  Widget build(BuildContext context) {
    print('init state    ${agent?.toJson()} refreshed ${refreshed} ');
    if(!refreshed) {
      getAgentData();
    } else {
      // _agent=agent;
    }
    return  refreshed ? _MaZoneAgentItem( agent:   agent,) :  const MaCardLoader();
  }
}

class MissingMaZoneAgentItem extends StatelessWidget {
 

   MissingMaZoneAgentItem({
    super.key,
    
    required this.onAgentSelected,
    required this.zoneId
  });
   final String zoneId;
  final void Function(MaUser) onAgentSelected ;
  openAgentSelectionModal(context){
                
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 550,
                          child: Column( 
                            children: [
                              Expanded(
                                child: FutureBuilder<List<MaUser>?>(
                                      future: MaUserController.getOpenAgents(zoneId), // a previously-obtained Future<String> or null
                                      builder: (BuildContext context, AsyncSnapshot<List<MaUser>?> snapshot) {
                                        Widget child;
                                        if (snapshot.hasData) {
                                          child = MaAgentSelction(
                                            agents: snapshot.data,
                                            onSelected: (agent){
                                                debugPrint('Selected agentId ${agent.userId}');
                                                onAgentSelected(agent);
                                                Navigator.pop(context);
                                            },
                                          );
                                        } else if (snapshot.hasError) {
                                          child = MaError(snapshot: snapshot ,);
                                        } else {
                                          child = MaSpinner();
                                        }
                                        return child;
                                      },
                                    )
                                
                              )
                            ],
                          ),
                        );
                      },
                    );
              }
  @override
  Widget build(BuildContext context) {
    
    return _agentCard(
            child: ListTile(
              title: const Text('No Agent Assigned') ,
              subtitle: const Text('Please Assigns an Agent') ,
              trailing: IconButton(
                  icon: Icon(Icons.person_add_alt),
                  onPressed: (){
                    openAgentSelectionModal(context);
                  },
              ),
            )
          );
  }
}

class MaAgentSelction extends StatelessWidget {
   const MaAgentSelction({
    super.key,
    required this.agents,
    required this.onSelected,
  });
  final void Function(MaUser) onSelected ;
  final List<MaUser>? agents;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: agents?.map((agent) { 
                    return ListTile(
                      leading: CircleAvatar( child: Text('${agent?.initial}'),),
                      title: Text('${agent?.fullname}') ,
                      subtitle: Text('${agent?.email}')  ,
                      onTap: (){
                        onSelected(agent);
                      },
                  );
                }).toList() ?? [],
    );
  }
}

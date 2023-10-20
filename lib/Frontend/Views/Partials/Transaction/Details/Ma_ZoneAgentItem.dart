import 'dart:math';

import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_UserController.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Error.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Utilities/widgets/MA_CardLoader.dart';
    

class _MaZoneAgentItem extends StatelessWidget {
  const _MaZoneAgentItem({
    super.key,
    required this.agent,
  });

  final MaUser? agent;

  @override
  Widget build(BuildContext context) {
    
    return _agentCard(
            child: ListTile(
                leading: CircleAvatar( child: Text('AG'),),
                title: Text('${agent?.firstname} - ${agent?.lastname}') ,
                subtitle: Text('Agent In charge') ,
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



class MaZoneAgentItem extends StatefulWidget {
   MaZoneAgentItem({
    super.key,
    required this.agent,
    required this.onAgentRefresh,
    required this.refreshed,
  });

   MaUser? agent;
  bool refreshed=false;
  final ValueChanged<MaUser?> onAgentRefresh;

  @override
  State<MaZoneAgentItem> createState() => _MaZoneAgentItemState();
}

class _MaZoneAgentItemState extends State<MaZoneAgentItem> {
  @override
  void initState() { 
    print('init state    ${widget.agent?.toJson()} widget.refreshed ${widget.refreshed} ');
    super.initState();
    if(!widget.refreshed) getAgentData();
    else {
      _agent=widget.agent;
    }
  }
  MaUser? _agent;
  bool loaded=false;
  Future<void> getAgentData() async{
      _agent = await MaUserController.getUserInfo(widget.agent?.userId ?? '');
      widget.onAgentRefresh(_agent);
      widget.refreshed = true;
      try {
        setState(() {}); 
      } catch (e) {
        print(e); 
      }
      
  }
  @override
  Widget build(BuildContext context) {
    print('widget.refreshed ${widget.refreshed} ');
    return  widget.refreshed ? _MaZoneAgentItem( agent:   _agent,) :  const MaCardLoader();
  }
}

class MissingMaZoneAgentItem extends StatelessWidget {
 

  const MissingMaZoneAgentItem({
    super.key,
    
    required this.onAgentSelected,
    required this.zoneId
  });
   final String zoneId;
  final void Function(MaUser) onAgentSelected ;


  @override
  Widget build(BuildContext context) {
    
    return _agentCard(
            child: ListTile(
              // leading: const Icon(Icons.person),
              title: const Text('No Agent Assigned') ,
              subtitle: const Text('Please Assigns an Agent') ,
              trailing: IconButton(icon: Icon(Icons.person_add_alt), onPressed: () {
                
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
                                            Agents: snapshot.data,
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
              }, ),
            )
    );
    
   
  }
}

class MaAgentSelction extends StatelessWidget {
   const MaAgentSelction({
    super.key,
    required this.Agents,
    required this.onSelected,
  });
  final void Function(MaUser) onSelected ;
  final List<MaUser>? Agents;
  @override
  Widget build(BuildContext context) {
    print(Agents.toString());
    return ListView(
      children: Agents?.map((agent) { 
              return ListTile(
                leading: CircleAvatar( child: Text('AG'),),
                title: Text('${agent?.firstname} ${agent?.lastname}') ,
                subtitle: Text('${agent?.email}')  ,
                onTap: (){
                 
                  onSelected(agent);
                },
            );
            }
    ).toList() ?? [],
    );
  }
}

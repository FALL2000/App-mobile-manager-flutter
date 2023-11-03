import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';

import '../../../Data/states/agent_state.dart';


class MaFilterAgent extends StatelessWidget {
  const MaFilterAgent({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AgentState agentState = Get.put(AgentState());
    return IconButton(
      icon: const Icon(
        Icons.filter_list,
        semanticLabel: 'filter by Status',
      ),
      onPressed: () {
        var widgets=MaConstants.CONST_AGENT_STATUS.values.toList().map((e){
          //debugPrint(e.label);
          return ListTile(
            trailing:  Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: e == MaConstants.CONST_AGENT_STATUS['disponible'] ? Colors.green: Colors.red,
              ),
            ),
            title: Text(e),
            onTap: () {
              agentState.filterAgents(e);
              Navigator.pop(context);
            },
          );
        }).toList();
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 150,
              child: Column(
                children: [
                  Expanded(
                      child: ListView(
                        children: widgets,
                      )
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}


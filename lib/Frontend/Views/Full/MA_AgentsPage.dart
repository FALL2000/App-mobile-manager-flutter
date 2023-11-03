import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:x_money_manager/Data/states/agent_state.dart';
import 'package:x_money_manager/Frontend/Views/Partials/agentWidget.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';
    
class MaAgentsPage extends StatelessWidget {

  MaAgentsPage({ Key? key }) : super(key: key);
  final AgentState agentState = Get.put(AgentState());
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context){
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent == _controller.position.pixels){
          agentState.getAgentsByPage();
      }
    });
     return Scaffold(
      body: Column(
          children: [
            _chipVisibility(),
            Expanded(
              child: buildList(_controller, context),
            ),
          ]
      ),
    );
  }

  Widget buildList(ScrollController _controller, BuildContext context){
    return Obx(() {
      if(agentState.isFinish.value){
        if(agentState.agents.length > 0){
          return RefreshIndicator(
            onRefresh: () => agentState.refreshAgents(),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              controller: _controller,
              itemCount: agentState.agents.length + 1,
              itemBuilder: (context, index) {
                if (index < agentState.agents.length) {
                  var item = agentState.agents[index];
                  return AgentWidget(agent: item, status: MaConstants.CONST_AGENT_STATUS,);
                } else {
                  if (agentState.hasMore.value)
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(child: CircularProgressIndicator(),),
                    );
                }
              },
            ),
          );
        }else{
          return Center(
            child: Text('No Agent', style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize)),
          );
        }
      }else{
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(child: CircularProgressIndicator(),),
        );
      }
    });
  }

  Widget _chipVisibility() {
    return Obx(() {
      final bool isFilter = agentState.isFilter.value;
      return isFilter
          ? Visibility(
        child: _buildChipList(),
        visible: true,
      )
          : Visibility(
        child: _buildChipList(),
        visible: false,
      );
    });
  }

  Widget _buildChipList(){
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        height: 40,
        child: ListView(
            reverse: true,
            scrollDirection : Axis.horizontal,
            children: _buildElement(),
        )
    );
  }

  List<Widget> _buildElement(){
    return agentState.agentStatus.map((e) =>
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Dismissible(
                direction : DismissDirection.vertical,
                onDismissed: (dir){
                    agentState.removeStatusInFilter(e);
                },
                key: Key(e) ,
                child: Chip(
                  elevation: 0.9,
                  backgroundColor: e == MaConstants.CONST_AGENT_STATUS['disponible']? Colors.green:Colors.red,
                  labelPadding: const EdgeInsets.symmetric(vertical: 2),
                  label:  Text(e, style:  TextStyle(color: Colors.white),),
                  deleteIcon:const  Icon(Icons.close),
                  deleteIconColor: Colors.white,
                  onDeleted: () {
                    agentState.removeStatusInFilter(e);
                  },
                )
            )
        )
    ).toList();
  }
}
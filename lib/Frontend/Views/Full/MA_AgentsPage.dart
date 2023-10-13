import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:x_money_manager/Data/states/agent_state.dart';
import 'package:x_money_manager/Frontend/Views/Partials/agentWidget.dart';
    
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
      body: Container(
        child: buildList(_controller),
      ),
    );
  }

  Widget buildList(ScrollController _controller){
    return Obx(()=>
      RefreshIndicator(
        onRefresh: () => agentState.refreshAgents(),
        child: ListView.builder(
            controller: _controller,
            itemCount: agentState.agents.length + 1,
            itemBuilder: (context, index){
              if(index < agentState.agents.length){
                var item = agentState.agents[index];
                return AgentWidget(agent: item);
              }else{
                if(agentState.hasMore.value)
                  return Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(child: CircularProgressIndicator(),),
                  );
              }
            }
        ),
      ),
    );
  }
}
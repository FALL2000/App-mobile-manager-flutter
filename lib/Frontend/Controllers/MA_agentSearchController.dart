import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Data/states/agent_state.dart';

import '../Views/Partials/agentWidget.dart';

class MAagentSearchController extends SearchDelegate {

  AgentState agentState = Get.find();
  final Map<String, String> status = {
    "disponible": "Available",
    "indisponible": "Unavailable"
  };

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    agentState.searchAgent(query);
    return Obx(()=>
          ListView.builder(
              itemCount: agentState.agentsSearch.length ,
              itemBuilder: (context, index){
                var item = agentState.agentsSearch[index];
                return AgentWidget(agent: item, status: status,);
              }
          ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    agentState.searchAgent(query);
    return Obx(()=>
        ListView.builder(
            itemCount: agentState.agentsSearch.length ,
            itemBuilder: (context, index){
              var item = agentState.agentsSearch[index];
              return AgentWidget(agent: item, status: status,);
            }
        ),
    );
  }
}
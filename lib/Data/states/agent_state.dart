import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:x_money_manager/Backend/MA_UserController.dart';
import 'package:x_money_manager/Data/mockData/agentMock.dart';

import '../../Model/MA_User.dart';

class AgentState extends GetxController{
  var agents = <MaUser>[].obs;
  var hasMore = true.obs;
  int page = 1;
  final limit = 15;
  List<MaUser> agentsList = [];

  @override
  void onInit() async{
    agentsList = await _getAgents();
    getAgentsByPage();
    super.onInit();
  }

  Future<void> refreshAgents() async {
    agents.clear();
    page = 1;
    hasMore.value = true;
    await Future.delayed(Duration(seconds: 2));
    getAgentsByPage();
  }

  @override
  void onClose() {
    print('enter enter');
    agents.clear();
    page = 1;
    hasMore.value = true;
    super.onClose();
  }

  Future<List<MaUser>> _getAgents() async{
    return MaUserController.getAgents();//await AgentMock.generateAgent(40);
  }

  void getAgentsByPage() async{
    List<MaUser> agentsSubList;
    if(page == 1){
      agentsSubList = limit > agentsList.length ? agentsList.sublist(0,agentsList.length) : agentsList.sublist(0,limit);
      if(limit >= agentsList.length)
        hasMore.value = false;
    }else{
      int totalElement = limit * page;
      if(totalElement > agentsList.length){
        int start= totalElement-limit < agentsList.length ? totalElement-limit : agentsList.length-1;
        agentsSubList = agentsList.sublist(start,agentsList.length);
        hasMore.value = false;
      }else{
        agentsSubList = agentsList.sublist(totalElement-limit,totalElement);
        if(totalElement == agentsList.length)
          hasMore.value = false;
      }
    }
    print("sublist ${agentsSubList.length}");
    agents.addAll(agentsSubList);
    page++;
  }
}
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:x_money_manager/Backend/MA_UserController.dart';
import 'package:x_money_manager/Data/mockData/agentMock.dart';

import '../../Model/MA_User.dart';

class AgentState extends GetxController{
  var agents = <MaUser>[].obs;
  var agentsSearch = <MaUser>[].obs;
  var agentStatus = <String>[].obs;
  var hasMore = true.obs;
  RxBool isFilter = false.obs;
  RxBool isFinish = false.obs;
  int page = 1;
  final limit = 15;
  bool isDispo = false;
  bool isIndispo = false;
  List<MaUser> agentsList = [];
  List<MaUser> agentsListFilter = [];

  @override
  void onInit() async{
    agentsList = await _getAgents();
    getAgentsByPage();
    super.onInit();
  }

  Future<void> refreshAgents() async {
    agents.clear();
    // agentsList = await _getAgents();
    page = 1;
    hasMore.value = true;
    isFinish.value = false;
    await Future.delayed(Duration(seconds: 2));
    getAgentsByPage();
  }

  @override
  void onClose() {
    print('enter enter');
    agents.clear();
    page = 1;
    hasMore.value = true;
    isFinish.value = false;
    super.onClose();
  }

  Future<List<MaUser>> _getAgents() async{
    return MaUserController.getAgents();//await AgentMock.generateAgent(40);
  }

  void searchAgent(String searchTerm){
    if(searchTerm != ''){
      List<MaUser> agentsResult = [];
      agentsResult.addAll(agentsList);
      agentsResult.retainWhere((element) =>
      element.lastname == null ? element.firstname.toUpperCase().contains(searchTerm.toUpperCase()) :
      element.firstname.toUpperCase().contains(searchTerm.toUpperCase()) || (element.lastname as String).toUpperCase().contains(searchTerm.toUpperCase()));
      agentsSearch.clear();
      agentsSearch.addAll(agentsResult);
    }else{
      if(agentsSearch.length > 0)
        agentsSearch.clear();
    }
  }

  void getAgentsByPage() {
     if(isFilter.value){
       print('--------------isfilter ----------');
       updateList(agentsListFilter);
     }else{
       print('--------------isNotfilter ----------');
       updateList(agentsList);
     }
     if(!isFinish.value) isFinish.value = true;
  }

  void updateList(List<MaUser> listOfAgents){
    List<MaUser> agentsSubList;
    if(hasMore.value){
      if(page == 1){
        agentsSubList = limit > listOfAgents.length ? listOfAgents.sublist(0,listOfAgents.length) : listOfAgents.sublist(0,limit);
        if(limit >= listOfAgents.length)
          hasMore.value = false;
      }else{
        int totalElement = limit * page;
        if(totalElement > listOfAgents.length){
          agentsSubList = listOfAgents.sublist(totalElement-limit,listOfAgents.length);
          hasMore.value = false;
        }else{
          agentsSubList = listOfAgents.sublist(totalElement-limit,totalElement);
          if(totalElement == listOfAgents.length)
            hasMore.value = false;
        }
      }
      print("sublist ${agentsSubList.length}");
      agents.addAll(agentsSubList);
      page++;
    }
  }

  void filterAgents(String status){
    if(!hasMore.value) hasMore.value = true;
    if(!isFilter.value) isFilter.value = true;
    isFinish.value = false;
    agents.clear();
    page = 1;
    if((status == 'Disponible' && !isDispo) || (status == 'Indisponible' && !isIndispo)){
      List<MaUser> agentsResult = [];
      agentsResult.addAll(agentsList);
      if(status == 'Disponible'){
        agentsResult.retainWhere((element) => element.workStatus == null);
        agentStatus.add(status);
        isDispo = true;
      }
      if(status == 'Indisponible'){
        agentsResult.retainWhere((element) => element.workStatus != null);
        agentStatus.add(status);
        isIndispo = true;
      }
      agentsListFilter.addAll(agentsResult);
    }
    getAgentsByPage();
  }

  void removeStatusInFilter(String status){
    if(!hasMore.value) hasMore.value = true;
    isFinish.value = false;
    agents.clear();
    page = 1;
    if(status == 'Disponible'){
       agentsListFilter.removeWhere((element) => element.workStatus == null);
       agentStatus.remove(status);
       isDispo = false;
    }
    if(status == 'Indisponible'){
      agentsListFilter.removeWhere((element) => element.workStatus != null);
      agentStatus.remove(status);
      isIndispo = false;
    }
    if(!isDispo && !isIndispo){
      isFilter.value = false;
    }
    getAgentsByPage();
  }
}
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:x_money_manager/Backend/MA_UserController.dart';
import 'package:x_money_manager/Data/mockData/agentMock.dart';

import '../../Model/MA_User.dart';

class AgentState extends GetxController{
  var agents = <MaUser>[].obs;
  var agentsSearch = <MaUser>[].obs;
  var hasMore = true.obs;
  bool isFilter = false;
  int page = 1;
  final limit = 15;
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

  void searchAgent(String searchTerm){
    if(searchTerm != ''){
      List<MaUser> agentsResult = [];
      agentsResult.addAll(agentsList);
      agentsResult.retainWhere((element) =>
      element.lastname == null ? element.firstname.contains(searchTerm) :
      element.firstname.contains(searchTerm) || (element.lastname as String).contains(searchTerm));
      agentsSearch.clear();
      agentsSearch.addAll(agentsResult);
    }else{
      if(agentsSearch.length > 0)
        agentsSearch.clear();
    }
  }

  void getAgentsByPage() {
     if(isFilter){
       print('--------------isfilter ----------');
       updateList(agentsListFilter);
     }else{
       print('--------------isNotfilter ----------');
       updateList(agentsList);
     }
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
    if(!isFilter) isFilter = true;
    agents.clear();
    page = 1;
    List<MaUser> agentsResult = [];
    agentsResult.addAll(agentsList);
    if(status == 'Disponible')
      agentsResult.retainWhere((element) => element.workStatus == null);
    if(status == 'Indisponible')
      agentsResult.retainWhere((element) => element.workStatus != null);
    agentsListFilter.addAll(agentsResult);
    getAgentsByPage();
  }
}
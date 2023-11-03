import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Full/MA_TransactionDetailsPage.dart';

import '../../../Model/MA_User.dart';

class AgentWidget extends StatelessWidget {
   MaUser agent;
   Map<String, String> status;
   AgentWidget({super.key, required this.agent, required this.status});

   MaterialColor colorDispo = Colors.green;
   MaterialColor colorInDispo = Colors.red;

  @override
  Widget build(BuildContext context) {
    Map<String, String> mapName = agent.lastname == null ? _buildName(agent.firstname, context) : _buildName(agent.firstname, context, agent.lastname);
    return Card(
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: agent.workStatus == null ? colorDispo: colorInDispo,
                ),
              ),
              SizedBox(width: 4),
              Text(mapName['name'] as String, style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize)),
            ],
          ),
          shape: RoundedRectangleBorder(
             side: BorderSide.none,
             borderRadius: BorderRadius.zero,
          ),
          subtitle: _buildSubtitle(context),
          collapsedIconColor: agent.workStatus == null ? colorDispo: colorInDispo,
          iconColor: agent.workStatus == null ? colorDispo: colorInDispo,
          leading: CircleAvatar(backgroundColor: agent.workStatus == null ? colorDispo: colorInDispo, child: Text(mapName['titleName'] as String),),
          children: [
            Column(
             children: [
               _childrens(context, mapName['subName'] as String)
             ],
          )],
          //childrenPadding: EdgeInsets.all(20),
        ),
    );
  }

  Widget _buildSubtitle(BuildContext context){
    if(agent.workStatus == null){
      return Text(status['disponible'] as String, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize, color: colorDispo));
    }else{
     // List<String> transactions = agent.workStatus?['transactions'] as List<String>;
      return Text(status['indisponible'] as String, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize, color: colorInDispo),);
    }
  }

  Widget _listTransaction(context){
    List<dynamic> transactions = agent.workStatus?['transactions'] ;//as List<String>;
    var listWidget = transactions.map((trans) =>
        TextButton(
          onPressed: () {
            
                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MaTransactionDetailsPage(requestId: trans, from: 'AG',)),
                        );
              
          },
          child: Text(
            trans as String,
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        )
    );
    List<Widget> widgets = listWidget.toList();
    //widgets.insert(0, Text("liste des transactions: ", style: TextStyle(color: Colors.white),));
    return Column(
      children: widgets
    );
  }

  Widget _childrens(BuildContext context, String name){
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left:25,top:10,right:10,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name,),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: _buildSubtitle(context),
                    ),
                  ),
                  width: 110.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:25,top:0,right:10,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: agent.workStatus == null ? [
                Text("This agent can be assign to a transaction",),
              ]:
              [
                _listTransaction(context)
              ],
            ),
          )
        ],
      );
  }

   Map<String, String> _buildName(String firstName, BuildContext context, [String? lastName]){
     double screenWidth = MediaQuery.of(context).size.width;
     double maxTitleLength = screenWidth / 20;
     String lName='';
     String name = lastName == null ? firstName: firstName+ ' ' + lastName;
     String fName = firstName.split(' ').length > 1 ? firstName.split(' ')[0].replaceFirst(firstName.split(' ')[0][0], firstName.split(' ')[0][0].toUpperCase()) : firstName.replaceFirst(firstName[0], firstName[0].toUpperCase());
     if(lastName != null)
        lName = lastName.split(' ').length > 1 ? lastName.split(' ')[0].replaceFirst(lastName.split(' ')[0][0], lastName.split(' ')[0][0].toUpperCase()) : lastName.replaceFirst(lastName[0], lastName[0].toUpperCase());
     String titleName = lName!='' ? fName[0].toUpperCase() + lName[0].toUpperCase() : fName[0].toUpperCase();
     return{
         "name": name.length > maxTitleLength? name.substring(0, maxTitleLength.toInt()) + '...':name,
         "subName":name,
         "titleName": titleName
     };
   }
}

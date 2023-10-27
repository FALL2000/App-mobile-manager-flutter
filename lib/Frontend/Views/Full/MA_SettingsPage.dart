import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Full/home.dart';

import '../../../Data/localStorage/MA_LocalStore.dart';
import '../../../Model/MA_User.dart';
import '../Partials/MA_Error.dart';
import '../Partials/MA_Spinner.dart';

class MaSettingsPage extends StatelessWidget {

  MaSettingsPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> childrens2 = [
      GestureDetector(
        child: _buildProfileUser(context),
        onTap: (){
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage()),
            );
        },
      ),
      Divider(color: Colors.grey[200],),
    ];
    childrens2.addAll(_builListTile(context));
    return Scaffold(
      body: Column(
         children: [
           Expanded(
             child: CustomScrollView(
               key: new Key('scrollView'),
               slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                         childrens2
                    ),
                  )
               ],
             ),
           )
         ],
      ),
    );
  }
  Widget _buildProfileUser(BuildContext context){
    return FutureBuilder<MaUser?>(
      future: MaLocalStore.getStoredUser(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<MaUser?> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          var _user = snapshot.data;
          String firstName = _user?.firstname ?? 'UNKNOW' ;
          String lastName = _user?.lastname ?? 'UNKNOW' ;
          child = _buildTitleAvatar(firstName, context, lastName);
        } else if (snapshot.hasError) {
          child = MaError(snapshot: snapshot ,);
        } else {
          child = MaSpinner();
        }
        return child;
      },
    );
  }
  Widget _buildTitleAvatar(String firstName, BuildContext context, [String? lastName]){
     Map<String, String> mapName = lastName == null ? _buildName(firstName):_buildName(firstName, lastName);
     return  Padding(
       padding: EdgeInsets.all(10),
       child: Row(
         children: [
           Column(
             children: [
               CircleAvatar(
                   backgroundColor:  Theme.of(context).colorScheme.primary,
                   radius: 40,
                   child: ClipOval(
                     child: Text(mapName['titleName'] as String, style: TextStyle(fontSize: 30, fontWeight: Theme.of(context).textTheme.headlineSmall?.fontWeight,color: Theme.of(context).colorScheme.onSecondary,),),
                   )
               )
             ],
           ),
           SizedBox(width: 20,),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(mapName['name'] as String,  style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, color: Theme.of(context).colorScheme.onPrimary, fontWeight: Theme.of(context).textTheme.headlineSmall?.fontWeight)),
               Text('Gestionnaire', style: TextStyle(color: Colors.grey),)
             ],
           )
         ],
       ),
     );
  }

  Map<String, String> _buildName(String firstName, [String? lastName]){
    try{
      if(lastName == null){
        String name = firstName.split(' ').length > 1 ? firstName.split(' ')[0].replaceFirst(firstName.split(' ')[0][0], firstName.split(' ')[0][0].toUpperCase())  + ' ' + firstName.split(' ')[1].replaceFirst(firstName.split(' ')[1][0], firstName.split(' ')[1][0].toUpperCase()) : firstName.replaceFirst(firstName[0], firstName[0].toUpperCase());
        String titleName = firstName.split(' ').length > 1 ? firstName.split(' ')[0][0].toUpperCase() + firstName.split(' ')[1][0].toUpperCase() : firstName[0].toUpperCase();
        return {
          "name": name,
          "titleName": titleName
        };
      }else{
        String fName = firstName.split(' ').length > 1 ? firstName.split(' ')[0].replaceFirst(firstName.split(' ')[0][0], firstName.split(' ')[0][0].toUpperCase()) : firstName.replaceFirst(firstName[0], firstName[0].toUpperCase());
        String lName = lastName.split(' ').length > 1 ? lastName.split(' ')[0].replaceFirst(lastName.split(' ')[0][0], lastName.split(' ')[0][0].toUpperCase()) : lastName.replaceFirst(lastName[0], lastName[0].toUpperCase());
        return{
          "name": fName + ' '+ lName,
          "titleName": fName[0].toUpperCase() + lName[0].toUpperCase()
        };
      }
    }
    catch( e) {
      return {
        "name": '',
        "titleName": ''
      };
    }
  }

  List<Widget> _builListTile(BuildContext context){
    final List<Map<String, dynamic>> elements = [
      {
        'name':'Langue',
        'icon': Icon(Icons.language,color: Theme.of(context).colorScheme.primary,)
      },
      {
        'name':'Notifications',
        'icon': Icon(Icons.notifications,color: Theme.of(context).colorScheme.primary,)
      },
      {
        'name':'Commentaire sur l\'application',
        'icon': Icon(Icons.comment,color: Theme.of(context).colorScheme.primary,)
      },
      {
        'name':'Aide',
        'icon': Icon(Icons.help,color: Theme.of(context).colorScheme.primary,)
      },
      {
        'name':'A propos',
        'icon': Icon(Icons.info,color: Theme.of(context).colorScheme.primary,)
      }
    ];
    return elements.map((e) =>
       ListTile(
         leading: e['icon'],
         title: Text(e['name'], style: TextStyle(fontSize: Theme.of(context).textTheme.bodySmall?.fontSize),),
       )
    ).toList();
  }
}
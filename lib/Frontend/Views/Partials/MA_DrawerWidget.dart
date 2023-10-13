import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Error.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Model/menu_item.dart';
import 'package:x_money_manager/Utilities/colors.dart';

import 'package:x_money_manager/Data/localStorage/MA_LocalStore.dart';
    
class MaDrawerWidget extends StatelessWidget {
  final XItem currentItem;
  // final ValueChanged<Category> onCategoryTap;
  final ValueChanged<XItem> onItemTap;
  const MaDrawerWidget({ Key? key,
    required this.currentItem,
    required this.onItemTap,
   }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final List<XItem> _items = XItemsRepository.loadXItems('');
    var children2 =  <Widget>[
         _buildDrawerHeader(context)
        ];

        children2.addAll(_items
            .map((XItem i) => _buildCategory(i, context))
            .toList());
    return Drawer(
      child: Container(
        // padding: const EdgeInsets.only(top: 40.0),
        color: kShrinePink100,
        child: ListView(
          padding: EdgeInsets.zero,
          children: children2,
        ),
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

  Widget _drawerHeader(String firstName, String mail, BuildContext context, [String? lastName]){
      Map<String, String> mapName = lastName == null ? _buildName(firstName) : _buildName(firstName, lastName);
      return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color:Color.fromARGB(255, 221, 209, 208),// Theme.of(context).colorScheme.secondary,
        ),
        accountName: Text(mapName['name'] as String, style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, color: Theme.of(context).colorScheme.onPrimary)),
        accountEmail: Text(mail, style: TextStyle(fontSize: Theme.of(context).textTheme.bodySmall?.fontSize, color: Theme.of(context).colorScheme.onPrimary)),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: ClipOval(
            child: Text(mapName['titleName'] as String , style: TextStyle(fontSize: 30, fontWeight: Theme.of(context).textTheme.headlineSmall?.fontWeight,),),
          ),
        ),
      );
  }

  Widget _buildDrawerHeader(BuildContext context){
    //return _drawerHeader("Nganda Onana", "fred@gmail.com", context, "fred");
  //  if(MaLocalStore.getStoredUser() == null){
  //     return _drawerHeader("UNKNOW", "UNKNOW", context);
  //  }else{
  //     String firstName = MaLocalStore.getStoredUser()?.firstname as String;
  //     String email = MaLocalStore.getStoredUser()?.email as String;
  //     String lastName = MaLocalStore.getStoredUser()?.lastname as String;
      
  //     return lastName.isEmpty ? _drawerHeader(firstName, email, context) : _drawerHeader(firstName, email, context, lastName);
  //  }
     return FutureBuilder<MaUser?>(
              future: MaLocalStore.getStoredUser(), // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<MaUser?> snapshot) {
                Widget child;
                if (snapshot.hasData) {
                  var _user = snapshot.data;
                  String firstName = _user?.firstname ?? 'UNKNOW' ;
                  String mail = _user?.email ?? 'UNKNOW' ;
                  String lastName = _user?.lastname ?? 'UNKNOW' ;
                  child = _drawerHeader(firstName, mail, context, lastName);
                } else if (snapshot.hasError) {
                  child = MaError(snapshot: snapshot ,);
                } else {
                  child = MaSpinner();
                }
                return child;
              },
      );

  }


  Widget _buildCategory(XItem item, BuildContext context) {
    final categoryString =item.label;
    final ThemeData theme = Theme.of(context);
    final bool isSelected= item.id == currentItem.id;
    return GestureDetector(
      onTap: ()  {
        onItemTap(item);
        if((item.path as String).isNotEmpty ){
          // Navigator.pushNamedAndRemoveUntil(context, item.route, ModalRoute.withName('/'));
          while (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          Navigator.pushReplacementNamed(context,item.route);
        }
        },
      child: _XItemWidget( item: item, theme: theme,isSelected:isSelected),
    );
  }
}

class _XItemWidget extends StatelessWidget {
  const _XItemWidget({
    super.key,
    required this.item,
    required this.theme,
    required this.isSelected,
  });

  final XItem item;
  final ThemeData theme;
  final bool isSelected;
  Color get iconColor =>  isSelected ? kShrineLight : kShrinePinkUnselected ;
  Color get textColor =>  isSelected ? kShrineLight : kShrinePinkUnselected ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 10),
      child: Row(
          children: <Widget>[
            Icon(item.icon, color: iconColor,),
            SizedBox(width: 5,),
            Text(
                  item.label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,

                  ),
                  //textAlign: TextAlign.center,
                ),
          ],
        ),
    );
  }
}
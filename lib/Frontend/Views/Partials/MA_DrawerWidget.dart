import 'package:flutter/material.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/model/menu_item.dart';
import 'package:x_money_manager/utilities/colors.dart';

import '../../../Data/localStorage/MA_LocalStore.dart';
    
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


  Widget _drawerHeader(String firstName, String mail, BuildContext context, [String? lastName]){
      String name =  lastName==null ? firstName.replaceFirst(firstName[0], firstName[0].toUpperCase()) :  firstName.replaceFirst(firstName[0], firstName[0].toUpperCase()) + ' ' + lastName.toString().replaceFirst(lastName.toString()[0], lastName.toString()[0].toUpperCase());
      String titleName = lastName==null ? firstName[0].toUpperCase() : firstName[0].toUpperCase() + lastName.toString()[0].toUpperCase();
      return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        accountName: Text(name, style: TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, color: Theme.of(context).colorScheme.primary)),
        accountEmail: Text(mail, style: TextStyle(fontSize: Theme.of(context).textTheme.bodySmall?.fontSize, color: Theme.of(context).colorScheme.primary)),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: ClipOval(
            child: Text(titleName, style: TextStyle(fontSize: 30, fontWeight: Theme.of(context).textTheme.headlineSmall?.fontWeight,),),
          ),
        ),
      );
  }

  Widget _buildDrawerHeader(BuildContext context){
    //return _drawerHeader("timene", "fred@gmail.com", context, "Fred");
    if(MaLocalStore.getStoredUser() == null){
      return _drawerHeader("UNKNOW", "UNKNOW", context);
    }else{
      String firstName = MaLocalStore.getStoredUser()?.firstname as String;
      String email = MaLocalStore.getStoredUser()?.email as String;
      String lastName = MaLocalStore.getStoredUser()?.lastname as String;
      
      return lastName.isEmpty ? _drawerHeader(firstName, email, context) : _drawerHeader(firstName, email, context, lastName);
    }

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
  Color get iconColor =>  isSelected ? kShrinePinkSelected : kShrinePinkUnselected ;
  Color get textColor =>  isSelected ? kShrinePinkSelected : kShrinePinkUnselected ;
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
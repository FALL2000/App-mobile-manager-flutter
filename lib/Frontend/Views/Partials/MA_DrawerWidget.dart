import 'package:flutter/material.dart';
import 'package:x_money_manager/model/menu_item.dart';
import 'package:x_money_manager/utilities/colors.dart';
    
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
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          /*ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),*/
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
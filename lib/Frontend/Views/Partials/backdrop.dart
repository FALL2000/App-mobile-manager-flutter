import 'package:flutter/material.dart';
// import 'package:x_money_manager/views/full/searchPage.dart';
import '../../../model/menu_item.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_DrawerWidget.dart';


class Backdrop extends StatefulWidget {
  final ValueChanged<XItem> onItemTap;
  final XItem currentXitem;
  final Widget frontLayer;
  final Widget frontTitle;
  const Backdrop({
    required this.currentXitem,
    required this.frontLayer,
    required this.frontTitle,
    required this.onItemTap,
    Key? key,
  }) : super(key: key);

  @override
  _BackdropState createState() => _BackdropState();

}

class _BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin {
  var ctime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(Backdrop old) {
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      title: widget.frontTitle,
      // actions: _buildBarActions(context),
    );
    return Scaffold(
            appBar: appBar,
            drawer: MaDrawerWidget(onItemTap:widget.onItemTap, currentItem: widget.currentXitem),
            body: WillPopScope(

              onWillPop: () {
                  if(Navigator.canPop(context)) return Future.value(true);
                  DateTime now = DateTime.now();
                  if (ctime == null || now.difference(ctime) > Duration(seconds: 2)) { 
                      //add duration of press gap
                      ctime = now;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Press Back Button Again to Exit')) 
                      ); 
                      return Future.value(false);
                  }

                  return Future.value(true);
              },

              child: widget.frontLayer,
            )
          
          );
  }

  List<Widget> _buildBarActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(
          Icons.search,
          semanticLabel: 'search',
        ),
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SearchPage()),
          );*/
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.person,
          semanticLabel: 'Profile', 
        ),
        onPressed: () {
          Navigator.pushNamed(context,'/Profile');
        },
      ),
    ];
  }
}

import 'package:flutter/material.dart';
// import 'package:x_money_manager/views/full/searchPage.dart';
import 'package:x_money_manager/Model/menu_item.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_DrawerWidget.dart';


import 'package:x_money_manager/Frontend/Controllers/MA_NavigationGetxCtrl.dart';

import 'package:get/get.dart';
class Backdrop extends StatefulWidget {
  // final ValueChanged<XItem> onItemTap;
  // final XItem currentXitem;
  final Widget frontLayer;
  final Widget frontTitle;
  final Widget? frontLeading;
  final List<Widget> Function(BuildContext context)? buildBarActions ;
  const Backdrop({
    // required this.currentXitem,
    required this.frontLayer,
    required this.frontTitle,
    this.frontLeading,
    // required this.onItemTap,
    this.buildBarActions,
    Key? key,
  }) : super(key: key);

  @override
  _BackdropState createState() => _BackdropState();

}

class _BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin {
  var ctime;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      leading: widget.frontLeading !=null ? GestureDetector(

                                                    onTap: () {
                                                      _scaffoldKey.currentState?.openDrawer();
                                                    },
                                                    child: IconButton(
                                                      padding: const EdgeInsets.only(right: 25.0),
                                                      onPressed: (){
                                                        _scaffoldKey.currentState?.openDrawer();
                                                      },
                                                      icon: Stack(children: <Widget>[
                                                        const Opacity(
                                                          opacity: 0.4,
                                                          child:  Icon(Icons.notes,),
                                                        ),
                                                        FractionalTranslation(
                                                          translation: Offset(1.0, 0.0),
                                                          child: widget.frontLeading,
                                                        )]),
                                                    ),
                                                )
                                              : null,
      actions: widget.buildBarActions!=null ? widget.buildBarActions!(context) : [],
    );
    return Scaffold(
            key: _scaffoldKey,
            appBar: appBar,
            drawer: const MaDrawerWidget(/*onItemTap:widget.onItemTap, currentItem: widget.currentXitem*/),
            body: WillPopScope(

              onWillPop: () {
                  if(Navigator.canPop(context)) {
                    final _controller = Get.put(MaNavigationGetxCtrl());
                       _controller.updateCurrent(items.homeItem,);
                    return Future.value(true);
                    }
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

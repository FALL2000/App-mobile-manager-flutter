import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Data/localStorage/MA_LocalStore.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_DashboardGetxCtrl.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_NavigationGetxCtrl.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionsGetxCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Error.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Utilities/widgets/MA_CardLoader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_money_manager/Utilities/widgets/MA_ExpansionPanelList.dart';
import 'package:x_money_manager/Utilities/widgets/MA_ExpansionTile.dart';
import 'package:x_money_manager/Model/menu_item.dart';

class MaHomePage extends StatefulWidget {
  const MaHomePage({Key? key}) : super(key: key);

  @override
  State<MaHomePage> createState() => _MaHomePageState();
}

class _MaHomePageState extends State<MaHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Container(
              // width: 300,
              height: 50,
              color: AppBarTheme.of(context).backgroundColor,
            ),
          ),
          // const Align(
          //   alignment: AlignmentDirectional.topStart,
          //   // left: 0,
          //   // top: 15,
          //   child: Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child: _userBox(),
          //   ),
          // ),
          Align(
            // alignment: const AlignmentDirectional(0, 0.6),
            alignment: AlignmentDirectional.topStart,
            child: SizedBox(
              // height: 400,
              // width: 400,
              child: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                     final controller = Get.put(MADashboardGetxCtrl());
                     await controller.refresh();
                  },
                  child: Column(
                    // physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: _userBox(),
                      ),
                      Expanded(
                        child: ListView(
                            // physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              Card(
                                elevation: 3,
                                child: MaExpansionTile(
                                  title: const Text(
                                      'Quick Actions'), //leading: Icon(Icons.),
                                  trailing: const Icon(Icons.link),
                                  initiallyExpanded: true,
                                  children: [
                                    Wrap(
                                        spacing:
                                            5.0, // gap between adjacent chips
                                        runSpacing: 14.0, // gap between lines
                                        children: <Widget>[
                                          QuickLink(
                                            item: items.transItem,
                                          ),
                                          QuickLink(
                                            item: items.agentItem,
                                          ),
                                          QuickLink(
                                            item: items.settingsItem,
                                          ),
                                        ]),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 3,
                                child: MaExpansionTile(
                                  expandedAlignment: Alignment.topLeft,
                                  childrenPadding: const EdgeInsets.only(
                                      left: 25, bottom: 10, top: 10),
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  title: const Text(
                                      'Transaction Reports'), //leading: Icon(Icons.),
                                  trailing: const Icon(Icons.table_chart),
                                  initiallyExpanded: true,
                
                                  children: [
                                    ChipReport(),
                                  ],
                                ),
                              ),
                              /*MaExpansionPanelList(
                          children: [
                            MAExpansionPanel(
                                headerBuilder: (context, isOpen) {
                                  return const ListTile(
                                      title: Text('Transactions Reports'),
                                      leading: Icon(Icons.tab));
                                },
                                body: Wrap(
                                    spacing: 5.0, // gap between adjacent chips
                                    runSpacing: 14.0, // gap between lines
                                    children: <Widget>[
                                      TextButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.monetization_on),
                                          label: const Text('Transactions')),
                                      TextButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.settings_suggest_outlined),
                                          label: const Text('Settings')),
                                      TextButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.group),
                                          label: const Text('Agents')),
                                    ])),
                          ],
                        ),*/
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChipReport extends StatelessWidget {
  ChipReport({
    super.key,
  });
  final controller = Get.put(MADashboardGetxCtrl());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>?>(
      future: controller
          .countByStatus(), // a previously-obtained Future<String> or null
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, int>?> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = GetBuilder<MADashboardGetxCtrl>(
              id: 'madashboard',
              init: MADashboardGetxCtrl(),
              builder: (controller) {
                return _ChipReport();
              });
        } else if (snapshot.hasError) {
          child = MaError(
            snapshot: snapshot,
          );
        } else {
          child = MaSpinner();
        }
        return child;
      },
    );
  }
}

class _ChipReport extends StatelessWidget {
  _ChipReport({
    super.key,
  });
  final MADashboardGetxCtrl controller = Get.find();
  final transCtrl = Get.put(TransactionsProvider());
  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 10.0, // gap between adjacent chips
        runSpacing: 5.0, // gap between lines
        children: controller.statusReport.map((e) {
          var icn = e.status;
          return GestureDetector(
            onTap: () {
              print('GestureDetector ${icn.label}');
              transCtrl.initFilter();
              transCtrl.updateStatusSet(e.status.key);
              Navigator.pushNamed(context, '/Transactions');
            },
            child: Badge(
              label: Text('${e.value}'),
              backgroundColor: icn.color,
              child: Chip(
                elevation: 0.9,
                // backgroundColor:  icn.color,
                labelPadding: const EdgeInsets.symmetric(vertical: 2),
                label: Text(
                  icn.label,
                  // style:  TextStyle(color: AppBarTheme.of(context).foregroundColor),
                ),
                side: BorderSide
                    .none, // BorderSide(color: Theme.of(context).colorScheme.primary,),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                // deleteIcon: Badge(
                //             label:  Text('${e.value}'),
                //             backgroundColor:icn.color,// Theme.of(context).colorScheme.tertiary,
                //           ),
                // deleteIconColor: Colors.white,
                // onDeleted: () {
                //   // controller.updateStatusSet(element,remove:true);
                // },
              ),
            ),
          );
        }).toList()

        // TextButton.icon(
        //     onPressed: () {},
        //     icon: const Icon(
        //         Icons.settings_suggest_outlined),
        //     label: const Text('Settings')),
        );
  }
}

class QuickLink extends StatelessWidget {
  QuickLink({super.key, required this.item});
  final XItem item;
  final controller = Get.put(MaNavigationGetxCtrl());
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          controller.updateCurrent(item);
          Navigator.pushNamed(context, item.route);
        },
        icon: Icon(item.icon),
        label: Text(item.label));
  }
}

class _userBox extends StatelessWidget {
  const _userBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MaUser?>(
      future: MaLocalStore.getStoredUser(),
      builder: (BuildContext context, AsyncSnapshot<MaUser?> snapshot) {
        Widget child = const MaCardLoader();
        if (snapshot.hasData) {
          child = UserCard(user: snapshot.data);
        } else if (snapshot.hasError) {
          //child =appWrapper( home: Scaffold(body: MaError(snapshot: snapshot ,)),);
        } else {
          child = MaSpinner(
            title: 'Welcome...',
          );
        }
        return child;
      },
    );
  }
}

class UserCard extends StatelessWidget {
  UserCard({super.key, this.user});
  MaUser? user;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 130,
        child: Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  shape: const Border(
                    top: BorderSide(color: Colors.transparent, width: 0),
                    bottom: BorderSide(color: Colors.transparent, width: 0),
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Hi,',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: ' ${user?.fullname}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  subtitle: Text('${user?.email}'),
                  trailing: Badge(
                    offset: const Offset(-0, -15),
                    textColor: AppBarTheme.of(context).foregroundColor,
                    label: Text(
                      'Active',
                      style: TextStyle(
                          color: AppBarTheme.of(context).foregroundColor),
                    ),
                    // padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.green,
                  ),
                ),
                // Visibility(
                //   visible: user?.flag?.isNotEmpty ?? false,
                //   child: Align(
                //     alignment :Alignment(0.0, 10.0),
                //     child: SizedBox(
                //             height: 40,
                //             width: 80,
                //             child: Padding(
                //               padding: const EdgeInsets.all(0.0),
                //               child: ClipRRect(
                //                 borderRadius: BorderRadius.circular(30),
                //                 child: SvgPicture.network(
                //                   '${user?.flag}',
                //                 ),
                //               ),
                //             ),
                //           ),
                //   )

                // )
                // _cardPaddedChild(
                //   child:  Row(
                //     children: [
                //       Badge(
                //         offset: Offset(25, 4),
                //         textColor:  AppBarTheme.of(context).foregroundColor,
                //         label: Text('Active',style:  TextStyle(color: AppBarTheme.of(context).foregroundColor),),
                //         // padding: const EdgeInsets.symmetric(vertical: 10),
                //         backgroundColor: Colors.green,
                //         child: Text('Account Status'),
                //         ),
                //       // Badge(
                //       //   backgroundColor: Colors.green,
                //       // )
                //     ],
                //   ),
                // ),
                // _cardPaddedChild(
                //   child: Text('Actively working on ${user?.workload0} items'),
                // ),
              ],
            )));
  }
}

class _cardPaddedChild extends StatelessWidget {
  _cardPaddedChild({super.key, this.child});
  Widget? child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: child,
    );
  }
}

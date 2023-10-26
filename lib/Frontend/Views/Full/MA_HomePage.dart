import 'package:flutter/material.dart';
import 'package:x_money_manager/Data/localStorage/MA_LocalStore.dart';
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
          const Align(
            alignment: AlignmentDirectional.topStart,
            // left: 0,
            // top: 15,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _userBox(),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, 0.6),
            child: SizedBox(
              height: 400,
              width: 400,
              child: SafeArea(
                child: ListView(
                  // physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Card(
                      elevation: 3,
                      child: MaExpansionTile(
                        title: Text('Quick Actions'), //leading: Icon(Icons.),
                        trailing: Icon(Icons.link),
                        initiallyExpanded: true,
                        children: [
                          Wrap(
                              spacing: 5.0, // gap between adjacent chips
                              runSpacing: 14.0, // gap between lines
                              children: <Widget>[
                                QuickLink(item: items.transItem,),
                                QuickLink(item: items.agentItem,),
                                QuickLink(item: items.settingsItem,),
                                
                                // TextButton.icon(
                                //     onPressed: () {},
                                //     icon: const Icon(
                                //         Icons.settings_suggest_outlined),
                                //     label: const Text('Settings')),
                              ]),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: MaExpansionTile(
                        expandedAlignment: Alignment.topLeft,
                        childrenPadding: const EdgeInsets.only(left: 25, bottom: 10),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        title: const Text('Transaction Reports'), //leading: Icon(Icons.),
                        trailing: Icon(Icons.table_chart),
                        initiallyExpanded: true,
                        children: [
                          Wrap(
                              spacing: 5.0, // gap between adjacent chips
                              runSpacing: 1.0, // gap between lines
                              children: <Widget>[
                               GestureDetector(
                                onTap: () {
                                  print('GestureDetector');
                                },
                                 child: Chip(
                                    elevation: 0.9,
                                    // backgroundColor:  icn?.color,
                                    labelPadding: const EdgeInsets.symmetric(vertical: 2),
                                    label:  Text('Pending', //style:  TextStyle(color: AppBarTheme.of(context).foregroundColor),
                                    ),
                                    deleteIcon: Badge(
                                                label: const Text('15'),
                                                backgroundColor: Theme.of(context).colorScheme.tertiary,
                                              ),
                                    deleteIconColor: Colors.white,
                                    onDeleted: () {
                                      // controller.updateStatusSet(element,remove:true);
                                    },
                                  ),
                               ),
                               Chip(
                                  elevation: 0.9,
                                  // backgroundColor:  icn?.color,
                                  labelPadding: const EdgeInsets.symmetric(vertical: 2),
                                  label:  Text('Pending', //style:  TextStyle(color: AppBarTheme.of(context).foregroundColor),
                                  ),
                                  deleteIcon: Badge(
                                              label: const Text('15'),
                                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                                            ),
                                  deleteIconColor: Colors.white,
                                  onDeleted: () {
                                    // controller.updateStatusSet(element,remove:true);
                                  },
                                ),
                               Chip(
                                  elevation: 0.9,
                                  // backgroundColor:  icn?.color,
                                  labelPadding: const EdgeInsets.symmetric(vertical: 2),
                                  label:  Text('Pending', //style:  TextStyle(color: AppBarTheme.of(context).foregroundColor),
                                  ),
                                  deleteIcon: Badge(
                                              label: const Text('15'),
                                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                                            ),
                                  deleteIconColor: Colors.white,
                                  onDeleted: () {
                                    // controller.updateStatusSet(element,remove:true);
                                  },
                                ),
                               Chip(
                                  elevation: 0.9,
                                  // backgroundColor:  icn?.color,
                                  labelPadding: const EdgeInsets.symmetric(vertical: 2),
                                  label:  Text('Pending', //style:  TextStyle(color: AppBarTheme.of(context).foregroundColor),
                                  ),
                                  deleteIcon: Badge(
                                              label: const Text('15'),
                                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                                            ),
                                  deleteIconColor: Colors.white,
                                  onDeleted: () {
                                    // controller.updateStatusSet(element,remove:true);
                                  },
                                ),
                                
                                // TextButton.icon(
                                //     onPressed: () {},
                                //     icon: const Icon(
                                //         Icons.settings_suggest_outlined),
                                //     label: const Text('Settings')),
                              ]),
                        ],
                      ),
                    ),
                    MaExpansionPanelList(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickLink extends StatelessWidget {
  const QuickLink({
    super.key,
    required this.item
  });
  final XItem item;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          Navigator.pushReplacementNamed(context,item.route);
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
        Widget child = MaCardLoader();
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
        height: 150,
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
                  trailing: user?.flag?.isNotEmpty ?? false
                      ? SizedBox.square(
                          dimension: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: SvgPicture.network(
                              '${user?.flag}',
                            ),
                          ),
                        )
                      : null,
                ),
                _cardPaddedChild(
                  child: const Row(
                    children: [
                      Text('Account Status Active'),
                      Badge(
                        backgroundColor: Colors.green,
                      )
                    ],
                  ),
                ),
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

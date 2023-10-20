import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Controllers/AuthController.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_agentSearchController.dart';
import 'package:x_money_manager/Frontend/Views/Full/MA_AgentsPage.dart';
import 'package:x_money_manager/Frontend/Views/Full/MA_SearchPage.dart';
import 'package:x_money_manager/Frontend/Views/Full/MA_TransactionsPage.dart';
import 'package:x_money_manager/Frontend/Views/Full/login.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_FilterAgent.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_FilterPage.dart';
import 'package:x_money_manager/Frontend/Views/Partials/backdrop.dart'; 
import 'package:x_money_manager/Frontend/Views/Full/home.dart'; 
import 'Utilities/colors.dart';
import 'package:x_money_manager/Model/menu_item.dart';
import 'package:get/get.dart';

class MoneyApp extends StatefulWidget {
  const MoneyApp({Key? key}) : super(key: key);

  @override
  State<MoneyApp> createState() => _MoneyAppState();
}

class _MoneyAppState extends State<MoneyApp> {
  final appState = Get.put(AuthController());
   XItem _curentItem = XItemsRepository.defaultItem();
    String _initialRoute='';
  void onXItemtap(XItem item) {
    setState(() {
      _curentItem = item;
      
    });
  }
  void setInitial(XItem item) {
    setState(() {
      _curentItem = item;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    print('_initialRoute ${appState.loggedIn}');
    if(!appState.loggedIn) {
      _initialRoute='/login';
      
    }else{
      _initialRoute='/';
    }
    print('_initialRoute $_initialRoute');
    
    return GetMaterialApp(
      title: 'Shrine',
      initialRoute: _initialRoute,
      routes: _buildRoutes,
      theme: _kShrineTheme,
    );
  }

  Map<String, Widget Function(BuildContext)> get _buildRoutes {
    var _routes ={
      '/login': (BuildContext context) =>  MALoginPage(),
      '/': (BuildContext context) => Backdrop(
              currentXitem: _curentItem,
              onItemTap: onXItemtap,
              frontLayer: HomePage(),
              frontTitle: Text(items.homeItem.label),
          ),
      '/Transactions': (BuildContext context) => Backdrop(
              currentXitem: _curentItem,
              onItemTap: onXItemtap,
              frontLayer: MaTransactionsPage(),
              frontTitle: Text(items.transItem.label),
              buildBarActions:(BuildContext context) {
                    return <Widget>[
                      const MATransactionSearchIcon(),
                      const MaFilterIcon(),
                    ];
              }
          ),
      '/Agents': (BuildContext context) => Backdrop(
              currentXitem: _curentItem,
              onItemTap: onXItemtap,
              frontLayer: MaAgentsPage(),
              frontTitle: Text(items.agentItem.label),
              buildBarActions:(BuildContext context) {
                    return <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          semanticLabel: 'search',
                        ),
                        onPressed: () {
                          showSearch(context: context, delegate: MAagentSearchController());
                        },
                      ),
                      const MaFilterAgent()
                    ];
                  }
          ),
        '/Settings': (BuildContext context) => Backdrop(
              currentXitem: _curentItem,
              onItemTap: onXItemtap,
              frontLayer: Placeholder(),
              frontTitle: Text(items.settingsItem.label),
          ),
    };

    return _routes;
  }
}

final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: kShrinePink100,
      onPrimary: kShrineBrown900,
      secondary: kShrineBrown900,
      error: kShrineErrorRed,
    ),
    textTheme: _buildShrineTextTheme(base.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: kShrinePink100,
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: kShrineLight,
      backgroundColor: kShrinePink100,
    ),
    searchBarTheme: SearchBarThemeData(
      backgroundColor: MaterialStateProperty.resolveWith((states){
        return kShrinePink100;
      }),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: kShrineBrown900,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: kShrineBrown900,
      ),
    ),
    iconTheme: const IconThemeData(
      color: kShrinePink100,
    )
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headlineSmall: base.headlineSmall!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        titleLarge: base.titleLarge!.copyWith(
          fontSize: 18.0,
        ),
        bodySmall: base.bodySmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodyLarge: base.bodyLarge!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: kShrineBrown900,
        bodyColor: kShrineBrown900,
      );
}

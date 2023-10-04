import 'package:flutter/material.dart';
import 'app.dart';
import 'package:x_money_manager/Frontend/Controllers/AuthController.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Error.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';
import 'package:get/get.dart';
// void main() => runApp(const MoneyApp());

void main() {
  final appState = Get.put(AuthController());
  runApp(
       FutureBuilder<bool>(
                      future: appState.init(),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        Widget child;
                        if (snapshot.hasData) {
                          child = const MoneyApp();
                        } else if (snapshot.hasError) {
                          child =appWrapper( home: Scaffold(body: MaError(snapshot: snapshot ,)),);
                        } else {
                          child =appWrapper( home: Scaffold(body: MaSpinner(title: 'Welcome...',)));
                        }
                        return child;
                      },
                    )
  );
}

class appWrapper extends StatelessWidget {
  final Widget home;

  const appWrapper({
    super.key,
    required this.home
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Namer App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          ),
          home: home
        );
  }
}

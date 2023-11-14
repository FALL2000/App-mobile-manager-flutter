import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoadingView extends StatefulWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;


  String notificationMsg = "Waiting for notifications";
  String typeNotif = "";
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.repeat();

}
    

  @override
  void dispose() {
    _animationController.dispose(); // Cancel the animation and dispose of the controller
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 50),
                child: Column(children: [
                  Image.asset('assets/logo.png'),
                  const  AspectRatio(aspectRatio: 100 / 3,),
                  Text(
                      'Welcome',
                      style:TextStyle(
                              fontSize: 65, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  const  AspectRatio(aspectRatio: 100 / 10,),
                  Text.rich(TextSpan(text: 'AppMoney is a money transfer application from one country to another.'),
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                  const  AspectRatio(aspectRatio: 100 / 14,),
                  SpinKitFadingCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 100.0,
                    controller: _animationController,
                  )
                ]))));
  }
}

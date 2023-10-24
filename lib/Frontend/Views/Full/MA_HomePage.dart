import 'package:flutter/material.dart';
import 'package:x_money_manager/Data/localStorage/MA_LocalStore.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Utilities/widgets/MA_CardLoader.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MaHomePage extends StatelessWidget {
  const MaHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title:  Text('Profile'),
      //   bottom:  PreferredSize(
      //         preferredSize: const Size.fromHeight(50),
      //         child: Card(),
      //   ),
      // ),
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
          Positioned(
            //<-- SEE HERE
            left: 0,
            top: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(
                  width: 400,
                  // height: 10,
                  // color: Colors.yellow,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: FutureBuilder<MaUser?>( future: MaLocalStore.getStoredUser(),
                      builder: (BuildContext context, AsyncSnapshot<MaUser?> snapshot) {
                        Widget child= MaCardLoader();
                        if (snapshot.hasData) {
                          child = UserCard2(user : snapshot.data);
                        } else if (snapshot.hasError) {
                          //child =appWrapper( home: Scaffold(body: MaError(snapshot: snapshot ,)),);
                        } else {
                          //child =appWrapper( home: Scaffold(body: MaSpinner(title: 'Welcome...',)));
                        }
                        return child;
                      },
                    )
                    /*
                    FutureBuilder(future: future, 
                    builder: builder)
                    UserCard(),*/
                  ),
                ),
                //   Container(
                //   width: 500,
                //   height: 70,
                //   color: Colors.blue,
                // ),
                // Flexible(child:

                //   ListView(
                //     children: const [
                //         ListTile(title: Text('Clofordf'),leading: Icon(Icons.abc_rounded),)
                //     ],
                //   )

                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  UserCard({
    super.key,
    this.user
  });
  MaUser? user;

  @override
  Widget build(BuildContext context) {
    print('-----user?.toJson()');
    print(user?.toJson());
    return Card(
        elevation: 3,
        child: ExpansionTile(
          clipBehavior: Clip.none,
          shape:  const Border( 
              top:  BorderSide(color: Colors.transparent , width: 0) ,
              bottom:  BorderSide(color: Colors.transparent , width: 0) ,
            ),
          childrenPadding: const EdgeInsets.only(left: 20),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          initiallyExpanded:true,
          title: Text('Hi ${user?.fullname}'),
          trailing: Icon(Icons.person),
          // leading: Icon(Icons.person),
          children: [
            Text('Account Status Active'),
            Text('Account Status Active')
            ],
        ));
  }
}
class UserCard2 extends StatelessWidget {
  UserCard2({
    super.key,
    this.user
  });
  MaUser? user;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment : CrossAxisAlignment.start,
          children: [
            ListTile(
              // clipBehavior: Clip.none,
              shape:  const Border( 
                  top:  BorderSide(color: Colors.transparent , width: 0) ,
                  bottom:  BorderSide(color: Colors.transparent , width: 0) ,
                ),
              // childrenPadding: const EdgeInsets.only(left: 20),
              // expandedCrossAxisAlignment: CrossAxisAlignment.start,
              // expandedAlignment: Alignment.topLeft,
              // initiallyExpanded:true,
              title: Text('Hi ${user?.fullname}'),
              subtitle: Text('${user?.email}'),
              trailing: user?.flag?.isNotEmpty ?? false ?
              SizedBox.square(
                dimension: 50,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SvgPicture.network(
                      '${user?.flag}',
                      // fit: BoxFit.cover,
                    ),
                  ),
              ): null,
              // leading: Icon(Icons.person),
              // children: [
              //   Text('Account Status Active'),
              //   Text('Account Status Active')
              //   ],
            ),
            
               
            _cardPaddedChild(child: Text('Account Status Active'), ),
            _cardPaddedChild(child: Text('Actively working on ${user?.workload0} items'), ),
            // _cardPaddedChild(child: Text('Account Status Active'), ),
            // _cardPaddedChild(child: Text('Account Status Active'))
          ],
        ));
  }
}

class _cardPaddedChild extends StatelessWidget {
   _cardPaddedChild({
    super.key,
    this.child
  });
  Widget? child; 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: child,
    );
  }
}

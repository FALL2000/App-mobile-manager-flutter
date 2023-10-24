import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Full/MA_TransactionDetailsPage.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_StatusIconWidget.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
    
class MaTransactionItem extends StatelessWidget {
 final MaTransaction transaction;
  const MaTransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  
  goToDetails(context){
    Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MaTransactionDetailsPage(requestId: transaction.id,)),
            );
  }
  @override
  Widget build(BuildContext context) {
   
    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          //debugPrint('width >>>> ${constraints.biggest.width} ');
          List<Widget> headers=[
            TextButton(
              child:Text(transaction.code),
              onPressed: (){
                goToDetails(context);
              },
            ),
            Expanded(
              child: Text('${transaction.formattedDate}',
                            textAlign: TextAlign.right,
              ),
            ),
          ];

          if(transaction.status?.isInProggress ?? false )
          {
            // headers.add(
            //     // Padding(
            //     //   padding: const EdgeInsets.only(left: 5,right: 5),
            //     //   child: Badge( 
            //     //       backgroundColor: /*Theme.of(context).colorScheme.secondary*/Colors.green, 
            //     //       smallSize: 15.5,),
            //     // ),
            // );
          }
           return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: headers,),
                ListTile(
                  onTap: () {
                      goToDetails(context);
                  },
                  title: Text(
                    transaction.formattedOutAmount,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  subtitle:Column(
                    crossAxisAlignment : CrossAxisAlignment.start,
                    children: [
                      Text('${transaction.from} - ${transaction.to}'),
                      Badge(
                        label: Text('${transaction.participants} participants'),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      )
                    ],
                  ) ,
                  trailing: MAStatusIconWidget(status: transaction.status?.keyValue),
                ),
              ],
            );
        }
      )
    );
  }

}
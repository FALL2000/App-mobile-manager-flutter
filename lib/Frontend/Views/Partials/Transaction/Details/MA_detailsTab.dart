import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionDetailsGetXCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_StatusIconWidget.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';
import 'package:x_money_manager/Utilities/widgets/outputs.dart';
class MaDetailsTab extends StatelessWidget {
  MaDetailsTab({
    super.key,
  });

  MaTransaction? request;
  final MaTransactionDetailsProvider controller = Get.find();
  @override
  Widget build(BuildContext context) {
    request= controller.transaction;
    var children=<Widget>[];
    bool hasGap= request?.gap != null;
    var _children0=[
              
             outputField(
              leading_icon: MaIcons.AMOUNT,
              label:'Amount:', value: request?.formattedOutAmount ?? '',
              hide_border: hasGap,
             ),
    ];
    if(hasGap){
      _children0.add(
          outputField(
              leading_icon: MaIcons.AMOUNT,
              label:'Gap:', value: request?.formattedgap ?? '',
              hide_border: true,
          ),
      );
    }
    

    children.addAll(_children0);

      var _children1=[
              
            outputField(
            leading_icon: MaIcons.PLACE,
            label:'From:', value: request?.from,
            hide_border: true,
            ),
          //  outputField(label:'codeReception :', value: request?.codeReception ?? ''),
            outputField(
            leading_icon: MaIcons.PLACE,
            label:'To:', value: request?.to,
            hide_border: true,
            ),
        ];
    
    children.addAll(_children1);
    
    final widgets=<Widget>[
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // children: actions,
        )
    ];
    

    widgets.addAll(children );

    return RefreshIndicator(
      onRefresh: () async{
            debugPrint('RefreshIndicator----start');
            await controller.doRefresh(); 
            debugPrint('RefreshIndicator----End');
          },
      child: Column(
        children: [
          Card( elevation: 5,
                  child: outputField(
                    // leading_icon: MaIcons.NUMBER,
                    label:request?.formattedDate ?? '', value: '${request?.participants} participants' ,
                    trailing:MAStatusIconWidget(status: request?.status?.keyValue), 
                    hide_border: true
                  ),
                ),
          Expanded(
            child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: widgets,
                  ),
          )
                ],
      ),
    );
    //Text('------Details of ${request.toString()}');
  }
}
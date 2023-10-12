import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionsGetxCtrl.dart';
import 'package:x_money_manager/Utilities/MA_TransactionUtils.dart';

class MaFilterIcon extends StatelessWidget {
  static final  controller = Get.put(TransactionsProvider());
  
  const MaFilterIcon({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
            icon: const Icon(
              Icons.filter_list,
              semanticLabel: 'filter by Status',
            ),
            onPressed: () {
              var widgets=MaStatusConfig.filterStatues.map((e)  {
                //debugPrint(e.label);
                return ListTile(
                    trailing: Icon(e.icon, color: e.color,),
                    title: Text(e.label),
                    onTap: ()async {
                      controller.updateStatusSet(e.key);
                      Navigator.pop(context);
                    },
                );
              }).toList();
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 250,
                    child: Column( 
                      children: [
                        Expanded(
                          child: ListView(
                            children: widgets,
                          )
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
  }
}


import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_ApprovalStatusIcon.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Utilities/widgets/outputs.dart';
    
class MaZoneApprovalItem extends StatelessWidget {
  const MaZoneApprovalItem({
    super.key,
    required this.approval,
  });

  final approvalTransaction? approval;

  @override
  Widget build(BuildContext context) {
    
    return ExpansionTile(
        // collapsedShape:const  Border( 
        //   top: BorderSide(color: Colors.transparent , width: 0) ,
        //   bottom: BorderSide( color: Colors.red ,width: 5) ,
        // ),
        shape:  Border( 
          top: const BorderSide(color: Colors.transparent , width: 0) ,
          bottom: BorderSide(color: Theme.of(context).colorScheme.primary , width: 1) ,
        ),
        leading: const Icon(Icons.mood_outlined),
        // leading: MaApprovalStatusIcon(status: approval?.status?.keyValue),
        // leading: CircleAvatar( child: Text('OUT'),),
        title: Text('${approval?.owner?.firstname}  ${approval?.owner?.lastname}') ,
        subtitle: Text('${approval?.formattedTotal}') ,
        trailing: MaApprovalStatusIcon(status: approval?.status?.keyValue),
        children: [
          outputField(value: '${approval?.formattedamount}', label: 'Amount', hide_border: true,),
          outputField(value: '${approval?.formattedfees}', label: 'Fees',hide_border: true,),
          ((approval?.owner?.email.isNotEmpty ?? false) || (approval?.owner?.phone?.isNotEmpty ?? false)) ? Text('${approval?.owner?.email} * ${approval?.owner?.phone}'): const SizedBox(height: 0.5,),
          Text('${approval?.formattedDate}'), 
        ],
    );
    
   
  }
}
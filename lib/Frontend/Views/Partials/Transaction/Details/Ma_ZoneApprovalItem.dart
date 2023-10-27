import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/MA_ApprovalStatusIcon.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Utilities/widgets/MA_ExpansionTile.dart';
import 'package:x_money_manager/Utilities/widgets/outputs.dart';
    
class MaZoneApprovalItem extends StatefulWidget {
  const MaZoneApprovalItem({
    super.key,
    required this.approval,
  });

  final approvalTransaction? approval;

  @override
  State<MaZoneApprovalItem> createState() => _MaZoneApprovalItemState();
}

class _MaZoneApprovalItemState extends State<MaZoneApprovalItem> {
  bool _isExpanded=false;
  IconData get _icon=> _isExpanded ? Icons.arrow_drop_down : Icons.arrow_right;
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Card(
        child: MaExpansionTile(
            onExpansionChanged: (value) {
              print(value);
              setState(() {
                _isExpanded= value;
              });
            },
            leading: Icon(_icon, size: IconTheme.of(context).opticalSize),
            title: Text('${widget.approval?.owner?.fullname}', overflow: TextOverflow.ellipsis,) ,
            subtitle: Text('${widget.approval?.formattedTotal}') ,
            trailing: MaApprovalStatusIcon(status: widget.approval?.status?.keyValue),
            children: [
              outputField(value: '${widget.approval?.formattedamount}', label: 'Amount', hide_border: true,),
              outputField(value: '${widget.approval?.formattedfees}', label: 'Fees',hide_border: true,),
              ((widget.approval?.owner?.email.isNotEmpty ?? false) || (widget.approval?.owner?.phone?.isNotEmpty ?? false)) ? Text('${widget.approval?.owner?.email} * ${widget.approval?.owner?.phone}'): const SizedBox(height: 0.5,),
              Text('${widget.approval?.formattedDate}'), 
            ],
        ),
      ),
    );
    
   
  }
}
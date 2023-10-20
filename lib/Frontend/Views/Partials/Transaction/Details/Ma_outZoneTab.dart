
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionDetailsGetXCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/MA_ZoneDetailsWidget.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneAgentItem.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneApprovalItem.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Model/MA_User.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';
import 'package:x_money_manager/Utilities/widgets/outputs.dart';
    

class MaOutZoneTab extends StatelessWidget {
   MaOutZoneTab({
    super.key,
  });
  final MaTransactionDetailsProvider controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return MaZoneDetailsWidget(
      key: const Key('2'),
      transactionId: controller.transaction?.id,
      approvals: controller.transaction?.outZoneDetails ?? [], 
      zoneId: controller.transaction!.outCountry?.id ?? '',
      agent: controller.transaction?.outZoneAgent,
      // gap: controller.transaction?.gap,
      refreshed: controller.outAgentRefreshed, //
      
      );
    
  }
}

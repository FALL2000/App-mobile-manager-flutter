import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Frontend/Controllers/MA_TransactionDetailsGetXCtrl.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/MA_ZoneDetailsWidget.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneAgentItem.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/Details/Ma_ZoneApprovalItem.dart';
import 'package:x_money_manager/Model/MA_Transaction.dart';
import 'package:x_money_manager/Model/MA_User.dart';
    

class MaInZoneTab extends StatelessWidget {
  MaInZoneTab({
    super.key,
  });
 var refreshed01=false;
 final MaTransactionDetailsProvider controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return MaZoneDetailsWidget(
      key: const Key('1'),
      transactionId: controller.transaction?.id,
      approvals: controller.transaction?.InZoneDetails ?? [], 
      zoneId: controller.transaction!.inCountry?.id ?? '',
      agent: controller.transaction?.InZoneAgent,
      refreshed: controller.inAgentRefreshed,
      
      );
  }
}

import 'package:get/get.dart';
import 'package:x_money_manager/Model/menu_item.dart';
class MaNavigationGetxCtrl extends GetxController{
  XItem? currentItem=XItemsRepository.defaultItem();

  updateCurrent(XItem item){
    currentItem=item;
    update();
  }
  
}
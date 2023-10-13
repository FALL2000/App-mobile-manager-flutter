import 'package:x_money_manager/Model/MA_User.dart';

class AgentMock{

  static MaUser _createUser(int number){
    if(number % 2 == 0){
      return MaUser(firstname: "TIMENE TSOTIE ${number}", email: "email ${number}", userId: "AG-000${number}", lastname: "FRED VICTOIRE");
    }else{
      return MaUser(firstname: "NGANDA ${number}", email: "email ${number}", userId: "AG-000${number}",
                     workStatus: {
                        "transactions":["TRANS-01${number}","TRANS-01${number}"]
                     }
                   );
    }

  }

  static Future<List<MaUser>> generateAgent(int size) async{
    await Future.delayed(const Duration(seconds: 2));
    if(size == 0) return [];
    final items = List<MaUser>.generate(size, (index) => _createUser(index));
    return items;
  }
}

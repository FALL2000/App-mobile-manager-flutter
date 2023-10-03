import 'package:x_money_manager/Backend/MA_FireFunctionsController.dart';
import 'package:x_money_manager/model/MA_Response.dart';
import 'package:x_money_manager/model/MA_Zone.dart';
import 'package:x_money_manager/Utilities/MA_Constants.dart';

class MaZoneController {
    static Future<List<MaCountry>> getCountries() async{
        
        const input = {
            'action': 'GET-ALL-WITH-CITIES'
        };
        var result= await MaFireFunctionsController.call(MaConstants.CONST_COUNTRY_FUNCION, input);
        // print(result);
        List<MaCountry> countries=[];
        if (!result.error){
          for (var element in result.body) {
            countries.add(MaCountry.fromJson(element));
          }

        }
        result.body=countries;
        
        return countries;
    }
}
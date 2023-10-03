import 'package:x_money_manager/model/MA_Zone.dart';

class ZoneUtils {
  static List<MaCity> getCities(List<MaCountry> countries, String countryId) {
        return countries.where((country) => 
            (country.id == countryId)
        ).firstOrNull?.cities?.toList() ?? [];
  }
  static List<MaCountry> minimizeCountries(List<MaCountry> countries) {
     return countries.map((e) => e.minimize()).toList();
  }
}
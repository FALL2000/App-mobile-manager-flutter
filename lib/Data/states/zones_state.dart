// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:flutter/material.dart';
import 'package:x_money_manager/Backend/MA_ZoneController.dart';
import 'package:x_money_manager/model/MA_Zone.dart';

class ZonesProvider extends ChangeNotifier{
  List<MaCountry> _countries=[];
  bool get hasCountries => _countries.isNotEmpty;

  List<MaCountry> get countries => _countries;
  set countries ( List<MaCountry> countries){
    _countries = countries;
    notifyListeners();
  }
  List<MaCountry> getCountries() {
    return countries.map((e) => e.minimize()).toList();
  }


  Future< List<MaCountry>> init() async {
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ zoneProvider ::::: initialize ');

    if(hasCountries) return countries;
    var __countries=await MaZoneController.getCountries();
    if(__countries.length>0){
      _countries=__countries;
      // return countries;
    }
    return countries;
  }
  List<MaCity> getCountryCities(String countryId) {
      return countries.where((country) => 
          (country.id == countryId)
      // ignore: sdk_version_since
      ).firstOrNull?.cities?.toList() ?? [];
  }
  MaCity? getCity(MaCountry? country, String? cityId) {
    if(country==null ) return null;
      return country!.cities!.where((city) => 
          (city.id == cityId)
      // ignore: sdk_version_since
      ).firstOrNull;
  }
  MaCountry? getCountry(String? countryId) {
      return countries.where((country) => 
          (country.id == countryId)
      // ignore: sdk_version_since
      ).firstOrNull;
  }
  
  
}
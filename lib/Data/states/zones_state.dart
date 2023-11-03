// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:x_money_manager/Backend/MA_ZoneController.dart';
import 'package:x_money_manager/model/MA_Zone.dart';

class ZonesProvider extends GetxController{
  var citiesOfCountry = <MaCity>[].obs;
  List<MaCountry> _countries=[];
  bool get hasCountries => _countries.isNotEmpty;

  List<MaCountry> get countries => _countries;
  set countries ( List<MaCountry> countries){
    _countries = countries;
  }
  List<MaCountry> getCountries() {
    return countries.map((e) => e.minimize()).toList();
  }

  Future<void> init() async{
    var __countries=await MaZoneController.getCountries();
    if(__countries.length>0){
      this.countries = __countries;
    }
  }
  void getCountryCities(String countryId) {
      citiesOfCountry.clear();
      citiesOfCountry.addAll(countries.where((country) =>
      (country.id == countryId)).firstOrNull?.cities?.toList() ?? [] as List<MaCity>);
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

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:x_money_manager/model/MA_Request.dart';
import 'package:x_money_manager/model/MA_Zone.dart';

var _cameroun= MaCountry(name: 'Cameroun', id: 'CMR',currencyCode: 'XAF', cities: [
                    MaCity(name: 'Douala', id: 'CMR-DLA'),
                    MaCity(name: 'Limbe', id: 'CMR-LIM'),
                    MaCity(name: 'Yaounde', id: 'CMR-YDE'),
                    MaCity(name: 'Bamenda', id: 'CMR-BMD'),
  ]) ;
  var _france= MaCountry(name: 'FRANCE', id: 'FR',currencyCode: 'EUR', cities: [
                      MaCity(name: 'Paris', id: 'FR-PAR'),
                      MaCity(name: 'Marseille', id: 'FR-MAR'),
  ]) ;
  var _italie= MaCountry(name: 'ITALIE', id: 'IT',currencyCode: 'EUR', cities: [
                      MaCity(name: 'Milan', id: 'IT-MIL'),
                      MaCity(name: 'Rome', id: 'IT-ROM'),
  ]) ;


class MaMockRepository {

  
  
  
  
  
  
  static List<MaCountry> getCountries() {

    return [
      _cameroun.minimize(),
      _france.minimize(),
      _italie.minimize()
    ];

  }

  static List<MaCity> getCountryCities(String countryId) {

    var _countries= [
      _cameroun,
      _france,
      _italie,
    ];

    return _countries.where((country) => 
         (country.id == countryId)
    // ignore: sdk_version_since
    ).firstOrNull?.cities?.toList() ?? [];

  }


  static Future<List<MaRequest>> generatesTransactions(int _size) async {
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@start MaMockRepository ::::: generatesTransactions $_size ');
    List<MaCountry>_countries = getCountries();
    var n= RequestStatus.values.length;
    await Future.delayed(const Duration(seconds: 2));
    if (_size == 0) return [];
    final items = List<MaRequest>.generate(_size, (index) {
      String _codeReception = 'REF-0000$index';
      String _amount= '${index*_size + 50}';
      bool tobank = ( index %3) ==1;
      var _request = MaRequest(amount: _amount, codeReception: _codeReception, toBank: tobank);
      if(!tobank) _request.receiptInfo = userReceiver(name: 'user $index', phone: '+552555-$index');
      if(tobank) _request.bankInfo = bankReceiver(name: 'Bank $index',title: '$index Account', number: '900-2563-635-$index');

      _request.inCountry= _countries[( index %3)];
      _request.outCountry= _countries[( (index+1) %3)];
      List<MaCity> inCities= getCountryCities( _request.inCountry?.id ?? '');
      List<MaCity> outCities= getCountryCities( _request.outCountry?.id ?? '');

      _request.incity= inCities[0];
      _request.outcity=outCities[0];
      _request.status= RequestStatus.values[(index+DateTime.now().millisecondsSinceEpoch)%n];// RequestStatus.open;
      _request.createdDate= DateTime.now().toIso8601String();
      _request.requestId=_codeReception;
      return _request;
    });

    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@end MaMockRepository ::::: generatesTransactions $_size ');
    return items;
  }

}


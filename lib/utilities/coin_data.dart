import 'dart:convert';

import 'package:http/http.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  late Response response;

  CoinData() {
    response = Response('', 500);
    timeStamp = '';
    coin = '';
    currency = '';
    price = 0;
  }

  CoinData.response(this.response) {
    data = response.body;
    var decodedData = jsonDecode(data!);
    timeStamp = decodedData["time"];
    coin = decodedData["asset_id_base"];
    currency = decodedData["asset_id_quote"];
    price = decodedData["rate"];
  }

  late final String? data;
  late final String timeStamp;
  late final String coin;
  late final String currency;
  late final double price;

  @override
  String toString() {
    return 'CoinData{timeStamp: $timeStamp, coin: $coin, currency: $currency, price: $price}';
  }
}

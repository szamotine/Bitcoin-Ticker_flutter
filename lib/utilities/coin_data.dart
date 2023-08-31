import 'dart:convert';

import 'package:bitcoin_ticker/services/network_helper.dart';
import 'package:http/http.dart';

class CoinData {
  late Response response;

  CoinData() {
    response = Response('', 500);
    timeStamp = DateTime.timestamp().toString();
    coin = 'BTC';
    currency = 'USD';
    price = 999;
  }

  CoinData.manualInput({required this.coin, required this.currency, required this.price}) {
    data = '';
    timeStamp = '';
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
  late String currency;
  late double price;

  @override
  String toString() {
    return 'CoinData{timeStamp: $timeStamp, coin: $coin, currency: $currency, price: $price}';
  }

  static Future<CoinData> getCoinData(String coin, String currency) async {
    Response response = await NetworkHelper.getCurrencyData(coin, currency);

    return NetworkHelper.responseToCoinData(response);
  }

  void coinDataRefresh() async {
    Response response = await NetworkHelper.getCurrencyData(coin, currency);
    CoinData newData = NetworkHelper.responseToCoinData(response);
    print('Old price: $price \nNewPrice: ${newData.price}');
    price = newData.price;
    //timeStamp = newData.timeStamp;
  }
}

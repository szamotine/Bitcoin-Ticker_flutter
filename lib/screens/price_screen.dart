import 'dart:io' show Platform;

import 'package:bitcoin_ticker/services/network_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utilities/coin_data.dart';
import '../utilities/constants.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  late CoinData coinData = CoinData();

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropdownItemsList = [];

    for (String currency in currenciesList) {
      dropdownItemsList.add(
        DropdownMenuItem(
          value: currency,
          child: Text(currency),
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItemsList,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value ?? '';
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItemList = [];
    for (String currency in currenciesList) {
      pickerItemList.add(
        Text(currency),
      );
    }
    return CupertinoPicker(
      offAxisFraction: -0.75,
      looping: true,
      itemExtent: 60,
      onSelectedItemChanged: (int value) {
        setState(() {
          selectedCurrency = currenciesList[value];
        });
      },
      children: pickerItemList,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else {
      return androidDropDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${coinData.price} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: kCoinDataTextStyle,
                ),
              ),
            ),
          ),
          FilledButton(
            onPressed: () async {
              coinData = NetworkHelper.responseToCoinData(await NetworkHelper.getCurrencyData('BTC', selectedCurrency));
              // coinData = CoinData.response(await NetworkHelper.getCurrencyData('BTC', selectedCurrency));
              setState(() {
                print(coinData.price);
              });
            },
            child: const Text('Get Price'),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: iOSPicker(),
          ),
        ],
      ),
    );
  }
}

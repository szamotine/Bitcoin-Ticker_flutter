import 'dart:io' show Platform;

import 'package:bitcoin_ticker/utilities/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/price_card.dart';
import '../utilities/constants.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  late DateTime t1;
  late DateTime t2;
  late bool firstInit = true;
  late double myprice = 1.00;

  late List<PriceCard> widgetList = [];

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
          // getPriceCards();
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

  Future<void> getPriceCards() async {
    List<PriceCard> priceCardList = [];
    CoinData coinData;

    if (!firstInit) {
      t2 = DateTime.timestamp();
    } else {
      firstInit = false;
    }

    Duration deltaTime = t2.difference(t1);

    if (deltaTime > const Duration(seconds: 3)) {
      print('Time difference is $deltaTime, updating getting coin data');
      priceCardList.clear();
      for (var coin in cryptoList) {
        coinData = await CoinData.getCoinData(coin, selectedCurrency);
        priceCardList.add(PriceCard(coinData: coinData));
      }
    } else {
      print('Time difference is $deltaTime');
    }

    widgetList = priceCardList;
    t1 = DateTime.timestamp();
  }

  Future<void> getPrice(String coin) async {
    CoinData temp = await CoinData.getCoinData(coin, selectedCurrency);

    myprice = temp.price;
  }

  double updatePrice(String coin) {
    getPrice(coin);
    return myprice;
  }

  @override
  initState() {
    super.initState();
    t1 = DateTime.timestamp();
    t2 = t1.add(const Duration(seconds: 5));
    setState(() {
      getPriceCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 150.0,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 30.0),
        color: Colors.lightBlue,
        child: iOSPicker(),
      ),
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          cryptoList.length,
          (index) => PriceCard(
            coinData: CoinData.manualInput(coin: cryptoList[index], currency: selectedCurrency, price: ++myprice),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../utilities/coin_data.dart';
import '../utilities/constants.dart';

class PriceCard extends StatefulWidget {
  PriceCard({
    super.key,
    required this.coinData,
  }) {
    // print('New Price card created. Coin: ${this.coin}, Currency: ${this.currency}');
  }

  final CoinData coinData;

  void updateCurrency(String newCurrency) {
    print('Updating currency from ${coinData.currency} to $newCurrency');

    coinData.currency = newCurrency;
    coinData.coinDataRefresh();
  }

  @override
  State<PriceCard> createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '1 ${widget.coinData.coin} = ${widget.coinData.price} ${widget.coinData.currency}',
            textAlign: TextAlign.center,
            style: kCoinDataTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('Price Card state init');
  }
}

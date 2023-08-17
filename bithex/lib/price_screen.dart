import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double rateBTC = 0.0;
  double rateETH = 0.0;
  double rateDOGE = 0.0;
  double rateBNB = 0.0;

  static const apiKey = '0F91814A-1AAD-43DF-921F-EE5690F82191';

  // static const apiKey = 'E92AAC9C-3EA0-4847-961B-5B7956X9E8DE';

  List<DropdownMenuItem<String>> getDropDownCurrencyList() {
    List<DropdownMenuItem<String>> items = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem<String>(
        value: currency,
        child: Text(currency),
      );
      items.add(newItem);
    }
    return items;
  }

  List<Text> getPickerList() {
    List<Text> items = [];
    for (String currency in currenciesList) {
      items.add(Text(currency));
    }
    return items;
  }

  Future<dynamic> getData(url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ResuableCard(
              rate: rateBTC, selectedCurrency: selectedCurrency, symbol: 'BTC'),
          ResuableCard(
              rate: rateETH, selectedCurrency: selectedCurrency, symbol: 'ETH'),
          ResuableCard(
              rate: rateDOGE,
              selectedCurrency: selectedCurrency,
              symbol: 'DOGE'),
          ResuableCard(
              rate: rateBNB,
              selectedCurrency: selectedCurrency,
              symbol: 'BNB'),
        ],
      ),
      bottomSheet: Container(
        height: 150.0,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 30.0),
        color: Colors.lightBlue,
        child: CupertinoPicker(
          itemExtent: 32,
          onSelectedItemChanged: (index) async {
            String newCurrency = currenciesList[index];
            var data1 = await getData(
              'https://rest.coinapi.io/v1/exchangerate/BTC/$newCurrency?apikey=$apiKey',
            );
            var data2 = await getData(
              'https://rest.coinapi.io/v1/exchangerate/ETH/$newCurrency?apikey=$apiKey',
            );
            var data3 = await getData(
              'https://rest.coinapi.io/v1/exchangerate/DOGE/$newCurrency?apikey=$apiKey',
            );
            var data4 = await getData(
              'https://rest.coinapi.io/v1/exchangerate/BNB/$newCurrency?apikey=$apiKey',
            );
            setState(() {
              if (data1 != null) {
                rateBTC = data1['rate'].toDouble();
                rateBTC = double.parse((rateBTC).toStringAsFixed(2));
                selectedCurrency = newCurrency;
                print('$selectedCurrency , $rateBTC');
              }
              if (data2 != null) {
                rateETH = data2['rate'].toDouble();
                rateETH = double.parse((rateETH).toStringAsFixed(2));
                selectedCurrency = newCurrency;
                print('$selectedCurrency , $rateETH');
              }
              if (data3 != null) {
                rateDOGE = data3['rate'].toDouble();
                rateDOGE = double.parse((rateDOGE).toStringAsFixed(2));
                selectedCurrency = newCurrency;
                print('$selectedCurrency , $rateDOGE');
              }
              if (data4 != null) {
                rateBNB = data4['rate'].toDouble();
                rateBNB = double.parse((rateBNB).toStringAsFixed(2));
                selectedCurrency = newCurrency;
                print('$selectedCurrency , $rateBNB');
              }
            });
          },
          children: getPickerList(),
        ),
      ),
    );
  }
}

class ResuableCard extends StatelessWidget {
  final double rate;
  final String selectedCurrency;
  final String symbol;

  ResuableCard(
      {required this.rate,
      required this.selectedCurrency,
      required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $symbol = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

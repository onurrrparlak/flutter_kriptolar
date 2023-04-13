import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../main.dart';
import '../models/crypto.dart';

class DetailsPage extends StatefulWidget {
  final Cryptocurrency cryptocurrency;

  const DetailsPage(this.cryptocurrency, {Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late List<CryptocurrencyHistoricalData> _historicalData;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getHistoricalData();
  }

  Future<void> _getHistoricalData() async {
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(Duration(days: 1));
    final String fromDate = DateFormat('dd-MM-yyyy').format(yesterday);
    final String toDate = DateFormat('dd-MM-yyyy').format(now);
    final String url =
        'https://api.coingecko.com/api/v3/coins/${widget.cryptocurrency.id}/market_chart?vs_currency=usd&days=1';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> prices = jsonResponse['prices'];

      setState(() {
        _isLoading = false;
        _historicalData = prices
            .map((data) => CryptocurrencyHistoricalData(
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                        (data[0] as int) * 1000,
                        isUtc: true)
                    .toLocal(),
                price: (data[1] as double)))
            .toList();
      });
    } else {
      throw Exception('Son 24 saat çekilirken hata oluştu');
    }

    print(response.body);
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(widget.cryptocurrency.name + ' Son 24 saat')),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <LineSeries<CryptocurrencyHistoricalData, DateTime>>[
                  LineSeries<CryptocurrencyHistoricalData, DateTime>(
                    dataSource: _historicalData,
                    xValueMapper: (data, _) => data.timestamp,
                    yValueMapper: (data, _) => data.price,
                  )
                ],
              ));
  }
}

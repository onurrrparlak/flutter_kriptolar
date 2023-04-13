import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'models/crypto.dart';
import 'views/crypto_details.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kripto Paralar Uygulaması',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Cryptocurrency> _cryptocurrencies;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getCryptocurrencies();
  }

  Future<void> _getCryptocurrencies() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
        _cryptocurrencies = List<Cryptocurrency>.from(jsonResponse.map(
            (json) => Cryptocurrency.fromJson(json as Map<String, dynamic>)));
      });
    } else {
      throw Exception('Hata oluştu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kripto Paralar')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cryptocurrencies.length,
              itemBuilder: (context, index) {
                final cryptocurrency = _cryptocurrencies[index];
                return Card(
                  child: ListTile(
                    leading: Text('${index + 1}'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(cryptocurrency),
                      ),
                    ),
                    title: Text(cryptocurrency.name),
                    subtitle: Text(
                        '\$${cryptocurrency.currentPrice.toStringAsFixed(2)}'),
                    trailing: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(cryptocurrency),
                        ),
                      ),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

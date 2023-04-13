class Cryptocurrency {
  final String id;
  final String name;
  final double currentPrice;

  Cryptocurrency(
      {required this.id, required this.name, required this.currentPrice});

  factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
    return Cryptocurrency(
      id: json['id'] as String,
      name: json['name'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
    );
  }
}

class CryptocurrencyHistoricalData {
  final DateTime timestamp;
  final double price;

  CryptocurrencyHistoricalData({required this.timestamp, required this.price});

  factory CryptocurrencyHistoricalData.fromJson(List<dynamic> json) {
    return CryptocurrencyHistoricalData(
      timestamp:
          DateTime.fromMillisecondsSinceEpoch(json[0] * 1000, isUtc: true)
              .toLocal(),
      price: (json[1] as num).toDouble(),
    );
  }
}

class Stock {
  final String code;
  final String name;
  final String exchange;

  Stock({
    required this.code,
    required this.name,
    required this.exchange,
  });

  factory Stock.fromYahoo(Map<String, dynamic> json) {
    return Stock(
      code: json['symbol'],
      name: json['shortname'] ??
          json['longname'] ??
          'Unknown',
      exchange: json['exchange'] ?? '',
    );
  }
}

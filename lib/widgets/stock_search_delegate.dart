import 'package:flutter/material.dart';
import '../stocks/stock_model.dart';
import '../stocks/stock_services.dart';

class StockSearchDelegate extends SearchDelegate<Stock?> {
  final StockService _service = StockService();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults();
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults();
  }

  Widget _buildResults() {
    return FutureBuilder<List<Stock>>(
      future: _service.searchStocks(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Search failed'));
        }

        final stocks = snapshot.data ?? [];

        if (stocks.isEmpty) {
          return const Center(child: Text('No stocks found'));
        }

        return ListView.builder(
          itemCount: stocks.length,
          itemBuilder: (context, index) {
            final stock = stocks[index];
            return ListTile(
              title: Text(stock.name),
              subtitle: Text('${stock.code} • ${stock.exchange}'),
              onTap: () => close(context, stock),
            );
          },
        );
      },
    );
  }
}

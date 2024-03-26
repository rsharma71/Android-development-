import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:robbinlaw/models/stock.dart';

class StockList extends StatefulWidget {
  const StockList({required this.stocks});

  final List<Stock> stocks;

  @override
  State<StatefulWidget> createState() {
    return _StockListState();
  }
}

class _StockListState extends State<StockList> {
  @override
  Widget build(BuildContext context) {
    return _buildStockList(context, widget.stocks);
  }

  ListView _buildStockList(context, List<Stock> stocks) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title:
              Text('Symbol: ${stocks[index].symbol}'),
            subtitle: 
              Text('Name: ${stocks[index].name}'),
            trailing: 
              Text('Price: \$${stocks[index].price} USD'),
          ),
        );
      },
    );
  }
}

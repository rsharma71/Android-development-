
import 'package:flutter/material.dart';
import 'package:robbinlaw/models/stock-list.dart';
import 'package:robbinlaw/models/stock.dart';
import 'dart:async';
import '../services/stock-service.dart';
import '../services/db-service.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final StockService stockService = StockService();
  final SQFliteDbService databaseService = SQFliteDbService();
  List<Map<String, dynamic>> stockList = [];
  
   var _stockList = <Stock>[];
  String stockSymbol = "";

  @override
  void initState() {
    super.initState();
    getOrCreateDbAndDisplayAllStocksInDb();
  }

  void getOrCreateDbAndDisplayAllStocksInDb() async {
    await databaseService.getOrCreateDatabaseHandle();
    _stockList = await databaseService.getAllStocksFromDb();
    await databaseService.printAllStocksInDbToConsole();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App 4 Stock Ticker'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text(
                'Delete All Records and Db',
              ),
              onPressed: () async {
                await databaseService.deleteDb();
                await databaseService.getOrCreateDatabaseHandle();
                _stockList = await databaseService.getAllStocksFromDb();
                await databaseService.printAllStocksInDbToConsole();
                setState(() {});
              },
            ),
            ElevatedButton(
              child: const Text(
                'Add Stock',
              ),
              onPressed: () {
                inputStock();
              },
            ),
            Expanded(
              child: StockList(stocks: _stockList),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> inputStock() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Input Stock Symbol'),
            contentPadding: const EdgeInsets.all(5.0),
            content: TextField(
              decoration: const InputDecoration(hintText: "Symbol"),
              onChanged: (String value) {
                stockSymbol = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Add Stock"),
                onPressed: () async {
                  if (stockSymbol.isNotEmpty) {
                    print('User entered Symbol: $stockSymbol');
                    var symbol = stockSymbol;
                    var companyName = '';
                    var price = '';
                    try {
                      //TODO:
                      //Inside of this try,
                      //get the company data with
                      //stockService.getCompanyInfo,
                      //then get the stock data with
                      //stockService.getQuote,
                      //but remember you must use await,
                      //then if it is not null,
                      //dig out the symbol, companyName, and latestPrice,
                      //then create a new object of
                      //type Stock and add it to
                      //the database by calling
                      //databaseService.insertStock,
                      //then get all the stocks from
                      //the database with
                      //databaseService.getAllStocksFromDb and
                      //attach them to stockList,
                      //then print all stocks to the console and,
                      //finally call setstate at the end.
                      if (stockSymbol.isNotEmpty) {
                          print('HomeView printAllStocksInListToConsole TRY');
                          try {

                            var companyName = await stockService
                                .getCompanyInfo(stockSymbol);
   
                            var data =
                                await stockService.getQuote(stockSymbol);
              
                            if (companyName != null) {
                              companyName = companyName['Name'];
                              if (data != null &&
                                  data['Global Quote'] != null) {
                                price = data['Global Quote']['05. price'];
                              
                                var stock = Stock(
                                    symbol: stockSymbol,
                                    name: companyName,
                                    price: price);
                                
                                await databaseService.insertStock(stock);
                            
                                _stockList =
                                    await databaseService.getAllStocksFromDb();
                                await databaseService
                                    .printAllStocksInDbToConsole();
                              }
                            } else {
                    
                              print(
                                  'Information for this symbol is not available.');
                            }
                          } catch (e) {
                            print('Stock Can Not Be Added(ERROR): $e');
                          }
                        
                          finally {
                            stockSymbol = "";
                            setState(() {});
                          }
                        }
                    } catch (e) {
                      print('HomeView inputStock catch: $e');
                    }
                  }
                  stockSymbol = "";
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}

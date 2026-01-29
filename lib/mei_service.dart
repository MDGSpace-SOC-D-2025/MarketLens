import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mei_model.dart';

class MEIService {
 
  Future<StockMEIData> fetchJSON_StockMEIData(String code) async {
  final response =
      await http.get(Uri.parse("http://10.61.1.176:8000/stock/$code"));

  final data = jsonDecode(response.body);
  return StockMEIData.fromJson(data);
}


  Future<List<int>> fetchMEIHistory(String code) async {
    final response = await http.get(Uri.parse("http://10.61.1.176:8000/stock/history/$code"));
    final data = jsonDecode(response.body);
    final List history= data['history'];
    final List<int> return_mei_values=[];
    
    for (int i=0; i<history.length;i++) {
      final rawMei = history[i]['mei'];
      return_mei_values.add(rawMei is int ? rawMei : (rawMei as num).round()
      );

    }

    return return_mei_values;
  }

  /*
  backend returns
  {
  "history": [
    { "mei": 52, "timestamp": ... },
    { "mei": 55, "timestamp": ... }
  ]
}

  */

  Future<Map<String, dynamic>> fetchMEItrend(String code) async {
    final response= await http.get(Uri.parse("http://10.61.1.176:8000/stock/historical_trend/$code"));
    final data=jsonDecode(response.body);
    return data;
    /*
    Gets:Trend, Momentum, Volatility, Alerts, Insights
    */

  }

  Future<String> sendAssistantQuery(String stock, String query) async {
    //calls POST /assistant_chat
  final response = await http.post(
    Uri.parse("http://10.61.1.176:8000/assistant_chat"),
    headers: {
      "Content-Type": "application/json",  
    },
    body: jsonEncode({
      "stock": stock,
      "question": query,
    }),
  );

  final data = jsonDecode(response.body);
  return data['reply'];
}



  

}
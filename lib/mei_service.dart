import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mei_model.dart';

class MEIService {
  Future <MEIData> fetchJSON() async {
    final response= await http.get(Uri.parse("http://10.87.174.11:8000/mei"));
    
    final data = jsonDecode(response.body);
    return MEIData.json_to_dart_obj(data);
    
  }
  Future <StockMEIData> fetchJSON_StockMEIData(String code) async {
    
    final response = await http.get(Uri.parse("http://10.87.174.11:8000/stock/$code"));
    print("STATUS CODE: ${response.statusCode}");
    print("RAW BODY: ${response.body}");

    final data = jsonDecode(response.body);
    return StockMEIData.json_to_dart_obj(data);
  }

  Future<List<int>> fetchMEIHistory(String code) async {
    final response = await http.get(Uri.parse("http://10.87.174.11:8000/stock/history/$code"));
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

  Future<Map<String, dynamic>> fetchMEItrend(String code) async {
    final response= await http.get(Uri.parse("http://10.87.174.11:8000/stock/historical_trend/$code"));
    final data=jsonDecode(response.body);
    return data;

  }

  Future<String> sendAssistantQuery(String stock, String query) async {
  final response = await http.post(
    Uri.parse("http://10.87.174.11:8000/assistant_chat"),
    body: {
      "stock": stock,
      "query": query,
    },
  );

  final data = jsonDecode(response.body);
  return data['response'];
  }

}
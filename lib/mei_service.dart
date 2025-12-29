import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mei_model.dart';

class MEIService {
  Future <MEIData> fetchJSON() async {
    final response= await http.get(Uri.parse("http://192.168.1.9:8000/mei"));
    
    final data = jsonDecode(response.body);
    return MEIData.json_to_dart_obj(data);
    
  }
  Future <StockMEIData> fetchJSON_StockMEIData(String code) async {
    final response = await http.get(Uri.parse("http://192.168.1.9:8000/stock/$code"));
    final data = jsonDecode(response.body);
    return StockMEIData.json_to_dart_obj(data);
  }

  Future<List<int>> fetchMEIHistory(String code) async {
    final response = await http.get(Uri.parse("http://192.168.1.9:8000/stock/history/$code"));
    final data = jsonDecode(response.body);
    final List history= data['history'];
    final List<int> return_mei_values=[];
    
    for (int i=0; i<history.length;i++) {
      return_mei_values.add(history[i]['mei']);
    }

    return return_mei_values;
  }

  Future<Map<String, dynamic>> fetchMEItrend(String code) async {
    final response= await http.get(Uri.parse("http://192.168.1.9:8000/stock/historical_trend/$code"));
    final data=jsonDecode(response.body);
    return data;

  }
}
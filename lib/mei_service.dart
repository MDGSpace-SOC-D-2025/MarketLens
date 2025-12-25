import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mei_model.dart';

class MEIService {
  Future <MEIData> fetchJSON() async {
    final response= await http.get(Uri.parse("http://192.168.1.5:8000/mei"));
    
      final data = jsonDecode(response.body);
      return MEIData.json_to_dart_obj(data);
    
  }


}

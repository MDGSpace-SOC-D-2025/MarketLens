//MEIDATA
class MEIData {
  final int value;
  final String trend;

  MEIData({required this.value, required this.trend});

  factory MEIData.json_to_dart_obj(Map <String, dynamic> json) {

    return MEIData(value: json['mei'], trend: json['trend']);
    
  }

}

//STOCK SPECIFIC MEI DATA

class StockMEIData{
  final String code;
  final int value;
  final String trend;
  final List<dynamic> headlines;

  StockMEIData({required this.code, required this.value, required this.trend, required this.headlines});

  factory StockMEIData.json_to_dart_obj(Map<String, dynamic> json){
    return StockMEIData(code: json['code'], value: json['mei'], trend: json['trend'], headlines: json['headlines']);
  }
}

class MEIData {
  final int value;
  final String trend;

  MEIData({required this.value, required this.trend});

  factory MEIData.json_to_dart_obj(Map <String, dynamic> json) {

    return MEIData(value: json['mei'], trend: json['trend']);
    
  }

}

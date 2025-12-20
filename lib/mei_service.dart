import 'dart:math';
//Will later be replaced by backend data
class MEIService {
  int _currentvalue=72;
  final Random _random=Random();

  int getNextValue(){
    int change=_random.nextInt(7)-3;
    _currentvalue=(_currentvalue+change).clamp(0, 100);
    return _currentvalue;

  }

  int getCurrentValue() {
    return _currentvalue;
  }
}

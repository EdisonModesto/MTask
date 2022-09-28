import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class counterProvider with ChangeNotifier{
  int totalTasks = 0, urgentTotal = 0, normalTotal = 0, farTotal = 0;

  void incrementTotal(){
    totalTasks += 1;
    notifyListeners();
  }

  void decrementTotal(){
    totalTasks -= 1;
    notifyListeners();
  }

  void incrementUrgent(){
    urgentTotal += 1;
    notifyListeners();
  }

  void decrementUrgent(){
    urgentTotal -= 1;
    notifyListeners();
  }

  void incrementNormal(){
    normalTotal += 1;
    notifyListeners();
  }

  void decrementNormal(){
    normalTotal -= 1;
    notifyListeners();
  }

  void incrementFar(){
    farTotal +=1 ;
    notifyListeners();
  }

  void decrementFar(){
    farTotal -=1 ;
    notifyListeners();
  }


}
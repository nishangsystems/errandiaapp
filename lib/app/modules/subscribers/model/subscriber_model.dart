class subscriber_model {

  String ? subscribedDate;
  String ? name;
  int ? msgCounter;
  bool ?isSelected=false;
  subscriber_model({this.msgCounter, this.name  , this.subscribedDate, this.isSelected});
}
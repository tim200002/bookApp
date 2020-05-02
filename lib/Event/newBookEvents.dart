import 'package:flutter/cupertino.dart';

abstract class NewBookEvents{}

//Look for new Book
class EventLookForBook extends NewBookEvents{
  int ISBN;
  EventLookForBook({@required this.ISBN});
}

class TestEvent extends NewBookEvents{
 
}


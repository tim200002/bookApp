
import 'package:book_app/State/StateHomeScreen.dart';
import 'package:book_app/model/book.dart';
import 'package:flutter/material.dart';

abstract class HomeEvents{}

//Event to Load all the Books for the List
class EventLoadData extends HomeEvents{}

//Event when Book updated
class EventBookUpdate extends HomeEvents{
  Book myBook;
  EventBookUpdate({@required this.myBook});
}

//Event when book finished
class EventBookFinished extends HomeEvents{
  Book myBook;
  EventBookFinished({@required this.myBook});
}
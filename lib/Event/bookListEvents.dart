
import 'package:book_app/model/book.dart';
import 'package:flutter/cupertino.dart';

abstract class BookListEvents{}

//Event to Load all the Books for the List
class EventLoadData extends BookListEvents{

}

//Change Order of List

class EventChangePosition extends BookListEvents{
  List<Book> bookList;
  
  EventChangePosition({@required this.bookList});

}

class EventDeleteBook extends BookListEvents{
 Book myBook;
  
  EventDeleteBook({@required this.myBook});

}
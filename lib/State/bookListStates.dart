import 'package:book_app/model/book.dart';
import 'package:flutter/cupertino.dart';

abstract class BookListStates{}

//State while making Calls and Loading Data
class FetchingData extends BookListStates{}

//State when Data is Loaded and one can Display Data
class ShowData extends BookListStates{
  List<Book> books;  //List of all the Books to Show

  ShowData({@required this.books});
}
class Loading extends BookListStates{}
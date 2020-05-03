import 'package:book_app/State/bookListStates.dart';
import 'package:book_app/model/book.dart';
import 'package:flutter/cupertino.dart';

abstract class HomeStates{}

//State while making Calls and Loading Data
class Loading extends HomeStates{}

//State when Data is loades and one can Disply Data
class ShowData extends HomeStates{
   List<Book> books;  //List of all the Books to Show
   //!Hard Coded at the Moment just for sytle
   int pagesOpen;
   ShowData({@required this.books, this.pagesOpen});
}
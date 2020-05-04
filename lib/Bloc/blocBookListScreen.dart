//Bloc for the Second Screen where one can see al the Books and push the Button to Add a book

import 'package:book_app/Event/bookListEvents.dart';
import 'package:book_app/State/bookListStates.dart';
import 'package:book_app/data/repository.dart';
import 'package:book_app/model/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocBookList extends Bloc<BookListEvents, BookListStates>{

  var repository=MainRepository();
  @override
  BookListStates get initialState => Loading();

  //Here Logic
  @override
  Stream<BookListStates> mapEventToState(BookListEvents event)async*{
    //Load all the Books from the DB in the right order
    if(event is EventLoadData){

      yield Loading();
      //Repository Function which returns List of all the Books  
      List<Book> books=await repository.getAllBooksSorted();
      yield ShowData(books: books);
    }
    else if (event is EventChangePosition){
      await repository.updatePosition(event.bookList);
    }
    else if (event is EventDeleteBook){
      await repository.deleteBookByID(event.myBook.id);
    }
  }
}
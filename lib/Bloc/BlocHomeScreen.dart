import 'dart:developer';

import 'package:book_app/Event/EventHomeScreen.dart';
import 'package:book_app/State/StateHomeScreen.dart';
import 'package:book_app/data/repository.dart';
import 'package:book_app/model/book.dart';
import 'package:book_app/model/statistics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


//Bloc for the MAin Screen
class BlocHomeScreen extends Bloc<HomeEvents, HomeStates> {
  var repository = MainRepository();
  @override
  HomeStates get initialState => Loading();

  @override
  Stream<HomeStates> mapEventToState(HomeEvents event) async* {
    if (event is EventLoadData) {
      yield Loading();
      //Repository Function which returns List of all the Books
      List<Book> books = await repository.getAllBooksSorted();
     

      //End Show Screen
      yield ShowData(books: books);
    }

    //Update the Pages Read today
    else if (event is EventBookUpdate) {
      int lastPages = 
          (await repository.getBookById(event.myBook.id)).currentPage; //last Value of Read pages
      await repository.updateBook(event.myBook); //my book already has new Pages
      int newPages =      event.myBook.currentPage;
         // (await repository.getBookById(event.myBook.id)).currentPage;
      await repository.updateRead(newPages -
          lastPages);//Updates Pages in Todays statistic entry //! Not ideal place because doesent change instantly -> can not to Bloc Call Every Time Counter could get extra BLoc or get Data directly in UI
    }
    
    else if (event is EventBookFinished){
      yield Loading();
      await repository.finishBook(event.myBook);
      EventLoadData();
      
    }
  }

}

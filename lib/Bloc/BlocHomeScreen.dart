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
      int readLeft; //Couter for how much to Read today
      yield Loading();
      //Repository Function which returns List of all the Books
      List<Book> books = await repository.getAllBooksSorted();
      String date = DateTime.now().toString().substring(0, 10); //Format Date Time in Format used in Database
      Statistic statistic = await repository.getStatisticsByDate(date); //Call to Statisitc Database to look how many pages already read and have to Read

      //Case New Day -> No Statistic for Current Day
      if (statistic == null) {
        //Add Element with Pages to Read -> Oages To Read = All Pages / Days left in the Year
        statistic =await repository.addStatisticWithPagesToRead((await repository.getTodaysPagesToRead())[1]);
      } 
      // Not all Pages Read for Today
      if (statistic.pagesRead < statistic.pagesToRead)
        readLeft = statistic.pagesToRead - statistic.pagesRead;
      else //Dont want negative Counter
        readLeft = 0;

      //End Show Screen
      yield ShowData(books: books, pagesOpen: readLeft);
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

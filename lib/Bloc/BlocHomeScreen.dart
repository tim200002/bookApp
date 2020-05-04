import 'dart:developer';

import 'package:book_app/Event/EventHomeScreen.dart';
import 'package:book_app/State/StateHomeScreen.dart';
import 'package:book_app/data/repository.dart';
import 'package:book_app/model/book.dart';
import 'package:book_app/model/statistics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocHomeScreen extends Bloc<HomeEvents, HomeStates> {
  var repository = MainRepository();
  @override
  HomeStates get initialState => Loading();

  @override
  Stream<HomeStates> mapEventToState(HomeEvents event) async* {
    if (event is EventLoadData) {
      int readLeft;
      yield Loading();

      //Repository Function which returns List of all the Books
      List<Book> books = await repository.getAllBooksSorted();
      String date = DateTime.now().toString().substring(0, 10);
      Statistic statistic = await repository.getStatisticsByDate(date);
      //NewDate
      if (statistic == null) {
        //Add Element with Pages to Read
        statistic =await repository.addStatisticWithPagesToRead((await repository.getTodaysPagesToRead())[1]);
      } else {
        //Pages to Read Today pagestoRead-pagesRead größer 0
        log(statistic.toString());
      }
      if (statistic.pagesRead < statistic.pagesToRead)
        readLeft = statistic.pagesToRead - statistic.pagesRead;
      else
        readLeft = 0;
      yield ShowData(books: books, pagesOpen: readLeft);
    }
    if (event is EventBookUpdate) {
      int lastPages =
          (await repository.getBookById(event.myBook.id)).currentPage;
      await repository.updateBook(event.myBook);
      int newPages =
          (await repository.getBookById(event.myBook.id)).currentPage;
      await repository.updateRead(newPages -
          lastPages); //! Not ideal place because doesent change instantly
    }
  }
}

import 'dart:developer';

import 'package:book_app/Event/newBookEvents.dart';
import 'package:book_app/State/NewBookStates.dart';
import 'package:book_app/data/repository.dart';
import 'package:book_app/model/book.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Bloc whicht Creates New book
class BlocNewBook extends Bloc<NewBookEvents, NewBookStates> {
  var repository = MainRepository();

  @override
  NewBookStates get initialState => EnterISBN();

  @override
  Stream<NewBookStates> mapEventToState(NewBookEvents event) async* {
    //Lookup Book and Add it to the DB, later not directly add it
    if (event is EventLookForBook) {
      try {
        int pages = (await repository.addBookByIsbn(event.ISBN)).pages;
        int daysTillNewYear=- DateTime.now().difference(DateTime(DateTime.now().year, 12,31)).inDays;
        log("Days Till New Year");
        log(daysTillNewYear.toString());
        pages = (pages / daysTillNewYear).ceil();
        if (pages == 0) pages = 1;
        await repository.updateTodaysToRead(pages);
      } catch (err) {
        log(err.toString());
      }
    }
    //Gets Deleted later
    if (event is TestEvent) {
      await repository.deleteALL();
      log("deleted");
    }
  }
}



import 'dart:developer';

import 'package:book_app/Event/newBookEvents.dart';
import 'package:book_app/State/NewBookStates.dart';
import 'package:book_app/data/repository.dart';
import 'package:book_app/model/book.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocNewBook extends Bloc<NewBookEvents, NewBookStates>{
      var repository=MainRepository();
  
  @override
  NewBookStates get initialState =>EnterISBN();

  @override
  Stream<NewBookStates> mapEventToState(NewBookEvents event)async*{

    //Lookup Book and Add it to the DB, later not directly add it
    if (event is EventLookForBook){
      Book myBook=Book(author: "Paul Coelho", title: "Veronika beschließt zu sterben", ISBN: 3257233051, isRead: false,pages: 224);
      repository.addNewBook(myBook);
    }
    if (event is TestEvent){
      log((await repository.getBookByPosition(0)).toString());
    }
  }
}
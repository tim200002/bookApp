

import 'dart:developer';

import 'package:book_app/Event/EventHomeScreen.dart';
import 'package:book_app/State/StateHomeScreen.dart';
import 'package:book_app/data/repository.dart';
import 'package:book_app/model/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocHomeScreen extends Bloc<HomeEvents, HomeStates>{

  var repository=MainRepository();
  @override
  HomeStates get initialState => Loading();

  @override
  Stream<HomeStates> mapEventToState(HomeEvents event)async*{

    if(event is EventLoadData){
      yield Loading();
    
      //Repository Function which returns List of all the Books
      List<Book> books=await repository.getAllBooksSorted();
      log("BÜcher ${books.length.toString()}");
       yield ShowData(books: books);

    }
  }
}
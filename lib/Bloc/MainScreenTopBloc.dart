//This Bloc is only for thr Top Widget in the Main Screen, so that it's content (Pages to Read) gets updates automatic

import 'package:book_app/data/repository.dart';
import 'package:book_app/model/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BlocMainTopEvents {}
class EventUpdateData extends BlocMainTopEvents{
  
}

abstract class BlocMainTopStates {}

class Loaded extends BlocMainTopStates{
  int pagesToRead;
  Loaded({@required this.pagesToRead});
}

class Loading extends BlocMainTopStates{
}

class BlocMainScreenTop extends Bloc<BlocMainTopEvents, BlocMainTopStates>{
  var repository = MainRepository();
  @override
  BlocMainTopStates get initialState =>Loading();

  @override
  Stream<BlocMainTopStates> mapEventToState(BlocMainTopEvents event)async*{
    if(event is EventUpdateData){
      int readLeft;
      yield Loading();
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
      yield Loaded(pagesToRead: readLeft);
    }
  }
}
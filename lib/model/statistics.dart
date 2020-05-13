import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class Statistic{
  String date; //style YYYY-MM-DD
  int pagesToRead;
  int pagesRead;
  int id =null;
  Statistic({@required this.date, @required this.pagesRead, @required this.pagesToRead, this.id});


  Map<String, dynamic> toMap(){
    Map<String,dynamic> map={
      'date': date,
      'pagesToRead': pagesToRead,
      'pagesRead': pagesRead
    };
    if(id!=null){
      map['id']=id;
    }
    return map;
  }

  Statistic.fromMap(Map<String,dynamic> map){
    date=map['date'];
    id=map['id'];
    pagesRead=map['pagesRead'];
    pagesToRead=map['pagesToRead'];
  }
}

class StatisticProvider{
  Database db;

  Future open()async{
    try{
      String _path=await getDatabasesPath()+'statistic.db';
      db=await openDatabase(_path,version: 1,onCreate: (Database db, int version)async{
        await db.execute('''create table statistic (id integer primary key autoincrement,
          date text, pagesToRead integer, pagesRead integer)''');

      });
    }
    catch(err){
      log(err.toString());
    }
  }

  Future<Statistic> getStatisticByDate(String date)async{
    try{
  List<Map> maps=await db.query("statistic", columns: ["id", "date", "pagesRead","pagesToRead"], where: "date = ?",whereArgs: [date]);
  if(maps.length>0){
    return Statistic.fromMap(maps.first);
  }
  return null;
    }
    catch(err){
      log(err.toString());
      return null; //! ToDo Should return something else to disitguis failed from no Statistic yet
    }
}

  Future<Statistic> insert(Statistic statistic)async{
    try{
      statistic.id=await db.insert("statistic", statistic.toMap());
      return statistic;
    }
    catch(err){
      log(err.toString());
      return null;
    }
  }

  Future<int> updateStatistic(Statistic statistic)async{
    return await db.update("statistic", statistic.toMap(),where: 'date = ?',whereArgs: [statistic.date]);
  }

  Future updateTodaysStatistic(String date, int newPages)async{
    int currentPages=(await getStatisticByDate(date)).pagesToRead;
    int pagesToRead=currentPages+newPages;
    if(pagesToRead<0) pagesToRead=0;
    log(pagesToRead.toString());
    var num=await db.update("statistic", {'pagesToRead': pagesToRead},where: 'date = ?',whereArgs: [date]);
    log(num.toString());
  }

    Future<int> deleteAll()async{
    return await db.delete("statistic");
  }
  Future closeDB() async=>db.close();
}


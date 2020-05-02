import 'dart:developer';

import 'package:book_app/model/book.dart';
import 'package:sqflite/sqflite.dart';

class BookList {
  int id;
  int bookId;
  int position;
  bool isRead;

  BookList(
      {this.id = null, this.bookId, this.position = 0, this.isRead = false});

  @override
  toString() {
    return "ID: $id bookID: $bookId  poition: $position  isRead: $isRead";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'bookId': bookId,
      'isRead': isRead == true ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id;
    }
    if (position != null) {
      map['position'] = position;
    }
    return map;
  }

  BookList.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    bookId = map['bookId'];
    position = map['position'];
    isRead = map['isRead'] == 1;
  }
}

class BookListProvider {
  Database db;

  Future open() async {
    String _path = await getDatabasesPath() + 'bookList.db';
    db = await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
  create table book_list ( 
  id integer primary key autoincrement,
  bookId integer,
  position integer,
  isRead integer 
''');
    });
  }
  // FOREIGN KEY (bookId) REFERENCES book (id) ON DELETE NO ACTION ON UPDATE NO ACTION)

  Future<BookList> insert(BookList list) async {
    log(list.toString());
    list.id = await db.insert("book_list", list.toMap());
    return list;
  }

  Future<BookList> getBookListById(int id) async {
    try {
      List<Map> maps = await db.query("book_list",
          columns: ['id', 'bookId', 'position', 'isRead'],
          where: 'id = ?',
          whereArgs: [id]);
      if (maps.length > 0) {
        return BookList.fromMap(maps.first);
      }
      return null;
    } catch (error) {
      log(error); //Error
      return null;
    }
  }

  //Get by Position
  Future<BookList> getBookListByPosition(int pos) async {
    try {
      List<Map> maps = await db.query("book_list",
          columns: ['id', 'bookId', 'position', 'isRead'],
          where: 'position = ?',
          whereArgs: [pos]);
      if (maps.length > 0) {
        return BookList.fromMap(maps.first);
      }
      return null;
    } catch (error) {
      log(error);
      return null;
    }
  }

  //Get All Active Booklist;
  Future<List<BookList>> getAllActive() async {
    try{
    List<Map> maps = await db.query("book_list",
        columns: ['id', 'bookId', 'position', 'isRead'],
        where: 'isRead = ?',
        whereArgs: [0]);
    if (maps.length > 0) {
      List<BookList> bookList = List<BookList>();
      maps.forEach((e) =>
          bookList.add(BookList.fromMap(e))); //Make a List of all entries
      return bookList;
    }
    return null;
    }
    catch(err){
      log(err);
      return null;
    }
  }

  //Update by ID
  //! No Errr yet
  Future<int> updateById(BookList list) async {
    return await db.update('book_list', list.toMap(),
        where: 'id = ?', whereArgs: [list.id]);
  }

  //Delete only
  Future<int> deleteById(int id) async {
    return await db.delete('book_list', where: 'id = ?', whereArgs: [id]);
  }

  //Delete All Entries:
  Future<int> deleteAll() async {
    return await db.delete("book_list");
  }
  //Update by Position

  Future closeDB() async => db.close();
}

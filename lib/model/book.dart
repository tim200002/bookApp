//This is the Class of a book

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Book {
   String title;
   String author;
   int pages;
  int currentPage;
   int ISBN;
   bool isRead;
   int id;

  //Constructor creates Book, if Page not known start at Page one
  Book(
      {@required this.title,
      @required this.author,
      @required this.pages,
      this.currentPage = 1,
      this.ISBN,
      this.isRead =false,
      this.id=null});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'author': author,
      'pages': pages,
      'currentPage': currentPage,
      'ISBN': ISBN,
      'isRead': isRead==true ?1:0 //Convert Bool to INT
    };

    //When ID sets then take it in lilst otherwise not
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Book.fromMap(Map<String, dynamic> map) {
        author= map['author'];
        title= map['title'];
        id= map['id'];
        pages= map['pages'];
        ISBN= map['ISBN'];
        currentPage= map['currentPage'];
        isRead= map['isRead']==1; //Convert int back to bool 
  }
  //Why factory
  factory Book.fromJson(Map<String,dynamic>json,int ISBN){

    //Wee first Need to Create an ISBN object because of the Structure of the response
    var isbn=ISBNClass.fromJson(json['ISBN:$ISBN']);

    //Chang Pages to number
    
    return Book(
      ISBN: ISBN,
      author: isbn.authors[0].name,
      title: isbn.title,
      pages: isbn.numberOfPages //Change later
    );
  }
}

class BookProvider {
  Database db;

  //Open Database if no Database create it
  Future open() async {
    log("opeining");
    String _path=await getDatabasesPath()+'book.db';
    db = await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      await db
          .execute('''create table book (id integer primary key autoincrement,
          author text, title text, pages integer, ISBN integer not null, currentPage integer, isRead integer)''');
    });
  }
  //Insert a book in the DB returns ID oft the book
  //! No Error Handling yet
  Future<Book> insert(Book book)async{
    book.id=await db.insert("book", book.toMap());
    return book;
  }


  Future<Book> getBookById(int id)async{
    try{
    List<Map> maps=await db.query("book",
    columns:["id","author", "title", "pages", "currentPage", "isRead", "ISBN"],
    where: 'id = ?',
    whereArgs: [id]);
    
    if (maps.length>0){
      return Book.fromMap(maps.first);
    }
    return null;
    }
    catch(error){
      log(error.toString());
          //Error
      return null;
    }

  }

//Returns number of Rows deleted shpuld equal 1
  Future<int> deleteById(int id)async{
    return await db.delete("book", where: 'id = ?',whereArgs: [id]);
  }

  //Delete All Entries:
  Future<int> deleteAll()async{
    return await db.delete("book");
  }

  //! No Error Handlig yet
  Future<int> updateBook(Book book)async{
    return await db.update("book", book.toMap(),where: 'id = ?', whereArgs: [book.id]);
  }

  Future closeDB() async=>db.close();
}




//! Helper Classes to Convert Json from API Call to Instance of Book

//Reads almost all Json
class ISBNClass{
  String title;
  int numberOfPages;
  List<Author> authors;

  ISBNClass({this.title,this.numberOfPages,this.authors});

  factory ISBNClass.fromJson(Map<String, dynamic>json){

    //Create the List of authors
    var authorFromJson=json['authors'];
    var myauthors= new List<Author>();
    authorFromJson.forEach((auth){myauthors.add(Author.fromJson(auth));}); //Does this work otherweise for Each
    String numberString=json["pagination"];
    numberString=numberString.replaceAll(RegExp("[^0-9]"), '');
    //REturn ISBN
    return ISBNClass(title: json["title"], numberOfPages: int.parse(numberString), authors: myauthors);
  }
}

//Authors are nestes in Json therefor this class
class Author{
  String name;
  Author({this.name});
  factory Author.fromJson(Map<String,dynamic> json){
    return Author(name: json['name']);
  }
}

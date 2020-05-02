//This is the Repository all Data Transfer happens here

//Main REpository Should Handle all the Data later maybe also a specialized one
//Repository is instantiated as a Singleton
import 'dart:developer';

import 'package:book_app/model/book.dart';
import 'package:book_app/model/bookList.dart';

class MainRepository {
  static final MainRepository _repo = new MainRepository._internal();

  //Connections to all the Databases -> here is the only Places Databse Calls happe

  BookProvider bookDB = BookProvider();
  BookListProvider bookListDB = BookListProvider();

  //Add a Book to the Book DB and Create an Entry in the Book List
  Future<int> addNewBook(Book book) async {
    try {
      //Check if DB COnnection opend
      //! Check again
      if (bookDB == null) await bookDB.open();
      if (bookListDB == null) await bookListDB.open();
      await bookDB.open();
      await bookListDB.open();

      //Search for highest positioon in Book Database to Add Book at right place
      var allBooks = await bookListDB.getAllActive();
      int max = -1;
      //If there is a book List -> find top position otherwise insert at 0
      if (allBooks != null) {
        //Find hightest position
        allBooks.forEach((element) {
          if (element.position > max) max = element.position;
        });
      }

      book = await bookDB.insert(book); //Important Book ID should be null

      //Create a Book List Object with ID matching to book
      var bookList = BookList(bookId: book.id, position: max + 1);
      await bookListDB.insert(bookList);
      return book.id;
    } catch (err) {
      log(err);
      return null;
    }
  }

  //Get Book by Position
  //Later Error Handling with invalid IDs important
  Future<Book> getBookByPosition(int pos) async {
    //Check if DB COnnection opend
    if (bookDB == null) await bookDB.open();
    if (bookListDB == null) await bookListDB.open();

    int bookId = (await bookListDB.getBookListByPosition(0)).bookId;
    return await bookDB.getBookById(bookId);
  }

  //Get all Books sorted
  Future<List<Book>> getAllBooksSorted() async {
    try{
    //Check if DB COnnection opend
    if (bookDB == null) await bookDB.open();
    if (bookListDB == null) await bookListDB.open();
    await bookDB.open();
    await bookListDB.open();
    //Get all active ELements
    var bookList = await bookListDB.getAllActive();
    //Therer are books
    if (bookList != null) {
      //Sort List in Ascending order:
      bookList.sort((a, b) => a.position.compareTo(b.position));

      List<Book> books = List<Book>();
      //Make a Book List
      bookList.forEach((element) async {
        books.add(await bookDB.getBookById(element.bookId));
      });
      return books;
    }
    //If not return empty list 
    return [];
    }
    catch(err){
      log(err);
      return [];  //REturn empty null would crash application
    }
  }

  deleteALL() async {
    if (bookDB == null) await bookDB.open();
    if (bookListDB == null) await bookListDB.open();
    await bookDB.open();
    await bookListDB.open();
    log(bookDB.db.toString());
    await bookDB.deleteAll();
    await bookListDB.deleteAll();
  }

//This Logic is to Create Singleton
  factory MainRepository() {
    return _repo;
  }
  MainRepository._internal() {}
}

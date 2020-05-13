//This is the Repository all Data Transfer happens here

//Main REpository Should Handle all the Data later maybe also a specialized one
//Repository is instantiated as a Singleton
import 'dart:convert';
import 'dart:developer';

import 'package:book_app/model/book.dart';
import 'package:book_app/model/bookList.dart';
import 'package:book_app/model/statistics.dart';
import 'package:http/http.dart' as http;

class MainRepository {
  static final MainRepository _repo = new MainRepository._internal();

  //Connections to all the Databases -> here is the only Places Databse Calls happe

  BookProvider bookDB = BookProvider();
  BookListProvider bookListDB = BookListProvider();
  StatisticProvider statisticDB=StatisticProvider();

  //Add a Book to the Book DB and Create an Entry in the Book List
  Future<int> addNewBook(Book book) async {
    try {
      //Check if DB COnnection opend
      //! Check again
      if (bookDB.db == null) await bookDB.open();
      if (bookListDB.db == null) await bookListDB.open();

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
      log(err.toString());
      return null;
    }
  }

  //Get Book by Position
  //Later Error Handling with invalid IDs important
  Future<Book> getBookByPosition(int pos) async {
    //Check if DB COnnection opend
    if (bookDB.db == null) await bookDB.open();
    if (bookListDB.db == null) await bookListDB.open();

    int bookId = (await bookListDB.getBookListByPosition(0)).bookId;
    return await bookDB.getBookById(bookId);
  }

  //Get all Books sorted
  Future<List<Book>> getAllBooksSorted() async {
    try {
      //Check if DB COnnection opend
      if (bookDB.db == null) await bookDB.open();
      if (bookListDB.db == null) await bookListDB.open();
      //Get all active ELements
      var bookList = await bookListDB.getAllActive();
      //Therer are books
      if (bookList != null) {
        //Sort List in Ascending order:
        bookList.sort((a, b) => a.position.compareTo(b.position));

        List<Book> books = List<Book>();
        //Needs to be for loop beacuse of await
        for (var book in bookList) {
          books.add(await bookDB.getBookById(book.bookId));
        }
        return books;
      }
      //If not return empty list
      return [];
    } catch (err) {
      log(err.toString());
      return []; //Return empty null would crash application
    }
  }

  //Returns all the pages to Read (index 0) and today pages to Read (index 1)
  Future<List<int>> getTodaysPagesToRead()async{
          //Check if DB COnnection opend
      if (bookDB.db == null) await bookDB.open();
      if (bookListDB.db == null) await bookListDB.open();
      List<int> pagesToRead=[0,0]; //Counter
      //Get all active ELements
      //Get all active ELements
      var bookList = await bookListDB.getAllActive();
      //Therer are books
      if (bookList!=null){
        for(var bookEntry in bookList){
          var book=await bookDB.getBookById(bookEntry.bookId);
          pagesToRead[0]+=(book.pages-book.currentPage)+1; //+1 Alleen Problem
        }
      }
      log(DateTime.now().difference(new DateTime.utc(DateTime.now().year+1,0,0)).inDays.toString());
      pagesToRead[1]=(pagesToRead[0]~/((DateTime.now().difference(new DateTime.utc(DateTime.now().year+1,0,0)).inDays))*-1);
      return pagesToRead;
      
  }
  Future deleteBookByID(int id)async{
      if (bookDB.db == null) await bookDB.open();
      if (bookListDB.db == null) await bookListDB.open();
      await bookListDB.deleteByBookId(id);
      await bookDB.deleteById(id);
  }

  deleteALL() async {
    if (bookDB.db == null) await bookDB.open();
    if (bookListDB.db == null) await bookListDB.open();
    if(statisticDB.db== null)await statisticDB.open();
    await bookDB.deleteAll();
    await bookListDB.deleteAll();
    await statisticDB.deleteAll();
  }

  //Get Book by ISBN Using API
  //! One could maybe remove this from Repository only called from unseude REpository
  Future<Book> findBookByISBN(int ISBN) async {
    try {
      //Get Data from API
      var response = await http.get(
          "https://openlibrary.org/api/books?bibkeys=ISBN:$ISBN&jscmd=data&format=json");
      if (response.statusCode != 200) {
        throw ("Calling API failed");
      } else if (response.body == '{}') {
        throw ("Book not found");
      } else {
        //Map data to book
        var myBook = Book.fromJson(json.decode(response.body), ISBN);
        return myBook;
      }
    } catch (err) {
      log(err.toString());
      return null; //Not Shure yet what to Return
    }
  }

  Future<Book> addBookByIsbn(int ISBN) async {
    try {
      if (bookDB.db == null) await bookDB.open();
      if (bookListDB.db == null) await bookListDB.open();
      var myBook = await findBookByISBN(ISBN);
      if (myBook != null) {
        await addNewBook(myBook);
        return myBook;
      }
      throw ("Error book == null");
    } catch (err) {
      log(err.toString());
      return null;
    }
  }

  Future<bool> updatePosition(List<Book> books) async {
    try {
      if (bookListDB.db == null) await bookListDB.open();
      return await bookListDB.changePosition(books);
      

    } catch (err) {
      return false;
    }
  }
  Future<int> updateBook(Book myBook)async{
    try{
      if (bookDB.db==null)await bookDB.open();
      return await bookDB.updateBook(myBook);
    }
    catch(err){
      log(err.toString());
      return null;
    }
  }
  Future<Book> getBookById(int id)async{
    if(bookDB.db==null)await bookDB.open();
    return await bookDB.getBookById(id);
  }

  Future<Statistic> getStatisticsByDate(String date)async{
    if(statisticDB.db==null) await statisticDB.open();
    return await statisticDB.getStatisticByDate(date);
  }
  Future<int> updateRead(int read)async{
    if (statisticDB.db==null)await statisticDB.open();
    Statistic old=await statisticDB.getStatisticByDate(DateTime.now().toString().substring(0,10));
    old.pagesRead+=read;
    return statisticDB.updateStatistic(old);
  }

  Future<Statistic> addStatisticWithPagesToRead(int pagesToRead)async{
    if(statisticDB.db==null) await statisticDB.open();
    Statistic stat=Statistic(date: DateTime.now().toString().substring(0,10),pagesRead: 0,pagesToRead: pagesToRead
    );
    return await statisticDB.insert(stat);
  }

  Future finishBook(Book mybook)async{
    if(statisticDB.db==null) await statisticDB.open();
    if(bookDB.db==null) await bookDB.open();
    mybook.isRead=true;
    //Update book no need to await
    bookDB.updateBook(mybook);
    bookListDB.finishBook(mybook.id);
  }

//This Logic is to Create Singleton
  factory MainRepository() {
    return _repo;
  }
  MainRepository._internal() {}
}

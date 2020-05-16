import 'package:book_app/Bloc/BasicNavigationBloc.dart';
import 'package:book_app/Bloc/blocBookListScreen.dart';
import 'package:book_app/Bloc/newBookBloc.dart';
import 'package:book_app/Event/bookListEvents.dart';
import 'package:book_app/State/bookListStates.dart';
import 'package:book_app/Styling/TextStyling.dart';
import 'package:book_app/Styling/colors.dart';
import 'package:book_app/model/book.dart';
import 'package:book_app/screens/addBookScreen.dart';
import 'package:book_app/widgets/progressCircle.dart';
import 'package:book_app/widgets/smallBlocTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    //Create Instance of BLOC
    final BlocBookList _blocBookList = BlocProvider.of<BlocBookList>(context);
    return BlocBuilder<BlocBookList, BookListStates>(
      builder: (context, state) {
        if (state is Loading) {
          _blocBookList.add(EventLoadData());
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is ShowData) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: MyColors.backgroundGrey,
              title: Text(
                "Order Your Library",
                style: MyTextStyle.bigHeadline,
              ),
            ), //At the Moment Necessary for Drawe
            drawer: Drawer(
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Home"),
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<BasicNavigationBloc>(context)
                            .add(NavigateToMainScreen());
                      },
                    ),
                    FlatButton(
                      child: Text("Book List"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  //! Wont Go with cupertino
                  Expanded(
                    child: ReorderableListView(
                      children: [
                        for (Book book in state.books)
                          SmallBlocTile(
                            book: book,
                            key: ValueKey(book.id),
                          )
                      ],
                      onReorder: (oldIndex, newIndex) {
                        state.books.insert(newIndex, state.books[oldIndex]);
                        //inserted below posisition
                        if (oldIndex > newIndex) {
                          state.books.removeAt(oldIndex + 1);
                        } else if (oldIndex < newIndex) {
                          state.books.removeAt(oldIndex);
                        }
                        _blocBookList
                            .add(EventChangePosition(bookList: state.books));
                        //? Dont know if nice but at the moment needed to show change in list
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: MyColors.mainAccentColor,
                      //Filled with accent color
                      child: Text("Press to Add Book",
                          style: MyTextStyle.mediumHeadline),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider<BlocNewBook>(
                                create: (BuildContext context) => BlocNewBook(),
                                child: AddBookScreen(),
                              );
                            },
                          ),
                        ).then((value) {
                          _blocBookList.add(
                              EventLoadData()); //Load updatetd data when return to screen

                          //Mybe better without extra call to DB
                          //return added Book an Manually add it to bookList, then setState
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

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
import 'package:flutter/cupertino.dart';
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
          return CupertinoPageScaffold(child: Text("Loading"));
        } else if (state is ShowData) {
          return CupertinoPageScaffold(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  //Headline
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Order Your Library",
                      style: MyTextStyle.bigHeadline,
                    ),
                  ),
                  //Scrollabe List

                   Expanded(
                    child: ListView.builder(
                      itemCount: state.books.length,
                      itemBuilder: (BuildContext ctxt, int index) =>
                          SmallBlocTile(
                        book: state.books[index],
                      ),
                    ),
                  ),
                 //! Wont Go with cupertino
                  Expanded(
                    child: ReorderableListView(
                      children: [
                        for (Book book in state.books)
                          SmallBlocTile(
                            book: book,key: ValueKey(book),
                          )
                      ],
                      onReorder: (oldIndex, newIndex) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoButton.filled(
                      //Filled with accent color
                      child: Text("Press to Add Book",
                          style: MyTextStyle.mediumHeadline),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return BlocProvider<BlocNewBook>(
                            create: (BuildContext context) => BlocNewBook(),
                            child: AddBookScreen(),
                          );
                        }));
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

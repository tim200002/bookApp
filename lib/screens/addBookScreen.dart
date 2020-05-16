import 'dart:developer';

import 'package:book_app/Bloc/newBookBloc.dart';
import 'package:book_app/Event/newBookEvents.dart';
import 'package:book_app/State/NewBookStates.dart';
import 'package:book_app/Styling/TextStyling.dart';
import 'package:book_app/Styling/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBookScreen extends StatefulWidget {
  AddBookScreen({Key key}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    final ISBNInputController = TextEditingController();

    //Create Instance of BLOC
    final BlocNewBook _blocNewBook = BlocProvider.of<BlocNewBook>(context);
    return BlocBuilder<BlocNewBook, NewBookStates>(
      builder: (context, state) {
        //State with Input Field to Enter ISBN
        if (state is EnterISBN) {
          return Scaffold(
              appBar: AppBar(
                  elevation: 0.0, backgroundColor: MyColors.backgroundGrey,title: Text(
                          "Enter ISBN to Add Book",
                          style: MyTextStyle.bigHeadline,
                          textAlign: TextAlign.center,
                        ),)
                  ,
              body: SafeArea(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //Input Field, later evtl. QR

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 20, right: 20),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter ISBN"),
                          controller: ISBNInputController,
                        ),
                      ),

                      RaisedButton(
                        child: Text(
                          "Search and Add Book",
                          style: MyTextStyle.mediumHeadline,
                        ),
                        onPressed: () {
                          try {
                            var isbn = int.parse(ISBNInputController.text);
                            _blocNewBook.add(EventLookForBook(ISBN: isbn));
                          } catch (err) {
                            log(err.toString());
                          }
                        },
                      ),
                      RaisedButton(
                        child: Text(
                          "Delete Everything",
                          style: MyTextStyle.mediumHeadline,
                        ),
                        onPressed: () {
                          _blocNewBook.add(TestEvent());
                        },
                      ),
                    ],
                  ),
                ),
              ));
        }
      },
    );
  }
}

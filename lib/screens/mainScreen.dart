import 'dart:developer';

import 'package:book_app/Bloc/BasicNavigationBloc.dart';
import 'package:book_app/Bloc/BlocHomeScreen.dart';
import 'package:book_app/Event/EventHomeScreen.dart';
import 'package:book_app/State/StateHomeScreen.dart';
import 'package:book_app/Styling/TextStyling.dart';
import 'package:book_app/model/book.dart';
import 'package:book_app/widgets/bigBookTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //Create Instance of Bloc
    final BlocHomeScreen _blocHomeScreen =
        BlocProvider.of<BlocHomeScreen>(context);
    return BlocBuilder<BlocHomeScreen, HomeStates>(
      builder: (context, state) {
        if (state is Loading) {
          _blocHomeScreen.add(EventLoadData());
          return Scaffold(body: Text("Loading 3"));
        } else if (state is ShowData) {
          return Scaffold(
            appBar: AppBar(), //At The Moment for App Drawer
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  FlatButton(
                    child: Text("Page 1"),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Text("Page 2"),
                    onPressed: () {
                      Navigator.pop(context);
                      BlocProvider.of<BasicNavigationBloc>(context)
                          .add(NavigateToListScreen());
                    },
                  )
                ],
              ),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Headline",
                      style: MyTextStyle.bigHeadline,
                    ),
                  ),
                  Expanded(
                                      child: ListView.builder(
                        itemCount: state.books.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return bigBookTile(book: state.books[index]);
                        }),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

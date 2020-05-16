import 'dart:developer';

import 'package:book_app/Bloc/BasicNavigationBloc.dart';
import 'package:book_app/Bloc/BlocHomeScreen.dart';
import 'package:book_app/Bloc/MainScreenTopBloc.dart' as helperBloc;
import 'package:book_app/Event/EventHomeScreen.dart';
import 'package:book_app/State/StateHomeScreen.dart';
import 'package:book_app/Styling/TextStyling.dart';
import 'package:book_app/Styling/colors.dart';
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
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is ShowData) {
          return Scaffold(
            appBar: AppBar(
                elevation: 0.0,
                backgroundColor:
                    MyColors.backgroundGrey), //At The Moment for App Drawer
            drawer: Drawer(

              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Home"),
                      onPressed: () {},
                    ),
                    FlatButton(
                      child: Text("Book List"),
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<BasicNavigationBloc>(context)
                            .add(NavigateToListScreen());
                      },
                    )
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  BlocBuilder<helperBloc.BlocMainScreenTop,
                      helperBloc.BlocMainTopStates>(
                    builder: (context, state) {
                      if (state is helperBloc.Loading) {
                        BlocProvider.of<helperBloc.BlocMainScreenTop>(context)
                            .add(helperBloc.EventShowData());
                        return Center(child: CircularProgressIndicator());
                      } else if (state is helperBloc.Loaded) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  width: 1.5, color: MyColors.borderGrey),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "You have to read",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(.0),
                                  child: Text(
                                    state.pagesToRead.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Pages Today",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
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

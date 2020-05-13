import 'dart:developer';

import 'package:book_app/Bloc/BasicNavigationBloc.dart';
import 'package:book_app/Bloc/BlocHomeScreen.dart';
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
          return Scaffold(body: Text("Loading 3"));
        } else if (state is ShowData) {
          
          return Scaffold(
            appBar: AppBar(elevation: 0.0,backgroundColor: MyColors.backgroundGrey), //At The Moment for App Drawer
            drawer: Drawer(
              
              child: SafeArea(
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
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border:
                            Border.all(width: 1.5, color: MyColors.borderGrey),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "You have to read",
                              style: MyTextStyle.mediumHeadline,
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(.0),
                            child: Text(state.pagesOpen.toString(), style: MyTextStyle.bigHeadline,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Pages Today",style: MyTextStyle.mediumHeadline,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("ps: you already read 2000 pages", style: MyTextStyle.smallText,),
                          )
                        ],
                      ),
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

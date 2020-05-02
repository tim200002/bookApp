import 'package:book_app/Bloc/BasicNavigationBloc.dart';
import 'package:book_app/Bloc/BlocHomeScreen.dart';
import 'package:book_app/Bloc/blocBookListScreen.dart';
import 'package:book_app/Styling/colors.dart';
import 'package:book_app/screens/ListScreen.dart';
import 'package:book_app/screens/mainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: MyColors.mainAccentColor),
        //theme(brightness: Brightness.light,primaryColor: MyColors.mainAccentColor),
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
            create: (BuildContext context) => BasicNavigationBloc(),
            child: BlocBuilder<BasicNavigationBloc, NavigationStates>(
              builder: (context, state) {
                if (state is StateMainScreen) {
                  return BlocProvider(
                      create: (BuildContext context) => BlocHomeScreen(),
                      child: HomeScreen());
                }
                //Show Detail Screen
                else if (state is StateListScreen) {
                  return BlocProvider(
                      create: (BuildContext context) => BlocBookList(),
                      child: ListScreen());
                }
              },
            )));
  }
}


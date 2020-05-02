import 'package:book_app/Bloc/BasicNavigationBloc.dart';
import 'package:book_app/Bloc/blocBookListScreen.dart';
import 'package:book_app/Bloc/newBookBloc.dart';
import 'package:book_app/Styling/colors.dart';
import 'package:book_app/model/book.dart';
import 'package:book_app/screens/ListScreen.dart';
import 'package:book_app/screens/addBookScreen.dart';
import 'package:book_app/widgets/bigBookTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light,primaryColor: MyColors.mainAccentColor),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<BasicNavigationBloc, NavigationStates>(
        bloc:
            BasicNavigationBloc(), //Necessary becaus no Bloc Provider and BLoc not in Build Context
        builder: (_, state) {
          //Show Main Screen
          if (state is StateMainScreen) {
            return BlocProvider(
                create: (BuildContext context) => BlocNewBook(),
                child: AddBookScreen());
          }
          //Show Detail Screen
          else if (state is StateListScreen) {
            return BlocProvider(
                create: (BuildContext context) => BlocBookList(),
                child: ListScreen());
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              bigBookTile(
                  book: Book(
                      author: "Hemingway",
                      title: "Ich weiß warum der gefangene Vogel weint",
                      pages: 300,
                      currentPage: 50)),
              bigBookTile(
                  book: Book(
                      author: "Hemingway",
                      title: "Ich weiß warum der gefangene Vogel weint",
                      pages: 300)),
            ],
          ),
        ),
      ),
    );
  }
}

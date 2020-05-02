import 'package:book_app/Bloc/newBookBloc.dart';
import 'package:book_app/Event/newBookEvents.dart';
import 'package:book_app/State/NewBookStates.dart';
import 'package:book_app/Styling/TextStyling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBookScreen extends StatefulWidget {
  AddBookScreen({Key key}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    //Create Instance of BLOC
    final BlocNewBook _blocNewBook = BlocProvider.of<BlocNewBook>(context);
    return BlocBuilder<BlocNewBook, NewBookStates>(
      builder: (context, state) {
        //State with Input Field to Enter ISBN
        if (state is EnterISBN) {
          return CupertinoPageScaffold(
            child: SafeArea(
                          child: Column(children: <Widget>[
                  CupertinoButton(
  
                  child: Text(
  
                    "Press me to Add A Book",
  
                    style: MyTextStyle.mediumHeadline,
  
                  ),
  
                  onPressed: (){
  
                    _blocNewBook.add(EventLookForBook(ISBN: 2));
  
                  },
  
                ),
                 CupertinoButton(
  
                  child: Text(
  
                    "Make Something Else",
  
                    style: MyTextStyle.mediumHeadline,
  
                  ),
  
                  onPressed: (){
  
                    _blocNewBook.add(TestEvent());
  
                  },
  
                ),
              ],),
            )

          );
        }
      },
    );
  }
}

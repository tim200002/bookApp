//I dont see the need for a statefull widget

import 'package:book_app/Bloc/blocBookListScreen.dart';
import 'package:book_app/Event/bookListEvents.dart';
import 'package:book_app/Styling/TextStyling.dart';
import 'package:book_app/Styling/colors.dart';
import 'package:book_app/model/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallBlocTile extends StatelessWidget {
  final Book book;
  final Key key;

  SmallBlocTile({@required this.book,this.key});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red,child: Icon(Icons.delete),),
      dismissThresholds: {DismissDirection.endToStart:0.5},
      key: this.key,
      onDismissed: (dir){
        BlocProvider.of<BlocBookList>(context).add(EventDeleteBook(myBook: book));

      },
      direction: DismissDirection.endToStart,
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        
        child: Container(
          width: double.infinity, //Full Size
          height: 60,
          
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(const Radius.circular(25 )),
              border: Border.all(width: 1.5, color: MyColors.borderGrey),
              color: MyColors.backgroundGrey),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Column(children: [
                Text(
                  book.author,
                  style: MyTextStyle.bigHeadline,
                ),
                Text(book.title, style: MyTextStyle.normalText),
                Text(
                  "${book.currentPage}/${book.pages}",
                  style: MyTextStyle.mediumHeadline,
                )
              ]),
               Padding(
                 padding: const EdgeInsets.only(right:20.0),
                 child: Align(alignment: Alignment.centerRight,child: Icon(Icons.reorder,)),
               ),
            ],
           

          ),
        ),
      ),
    );
  }
}

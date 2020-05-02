import 'package:book_app/Styling/TextStyling.dart';
import 'package:book_app/Styling/colors.dart';
import 'package:book_app/model/book.dart';
import 'package:book_app/widgets/progressCircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Class to create a book Tile
class bigBookTile extends StatefulWidget {
  bigBookTile({@required this.book, Key key}) : super(key: key);

  //Some Variables Used to Display the content od the tile
  final Book book;
 

  @override
  _bigBookTileState createState() => _bigBookTileState();
}

class _bigBookTileState extends State<bigBookTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:12.0,bottom: 12, left: 20,right: 20), //Outside Padding two separate
      child: GestureDetector(
        onTap: (){
         
           showCupertinoModalPopup(context: context, builder: (BuildContext context)=>CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged:(int i){
            widget.book.currentPage= i+1;
             setState(() {
            
          }); //Later over bloc
          } , //later
          children: <Widget>[
            Text("1"),
            Text("2"),
            Text("3")
          ],

        ));
                    
        },
              child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(const Radius.circular(25)),
              border: Border.all(width:1.5,color: MyColors.borderGrey),
              color: MyColors.backgroundGrey),
          padding: const EdgeInsets.all(10), //Inside Padding of Content
          child: Column(
            children: <Widget>[
              //Big Top Headline
              Text(widget.book.title, style: MyTextStyle.bigHeadline,textAlign: TextAlign.center,),
              //Bar below
              Divider(color: Colors.black,thickness: 2,height: 25,),
              //Column for Progress and both Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[

                  //Minus Circle
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: MyColors.foregroundGrey),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text("-",style: MyTextStyle.iconStyle,),
                        ),
                  ),
                //Progress Thing
                Container(height: 200,child: CircularProgress(animationDuration: Duration(milliseconds: 500),backgroundColor: MyColors.progressNotColor,foregroundColor: MyColors.progressDoneColor, currentPage: widget.book.currentPage, pages: widget.book.pages)),
                //Plus Circle
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: MyColors.foregroundGrey),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text("+",style: MyTextStyle.iconStyle,),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

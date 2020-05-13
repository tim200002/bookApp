import 'dart:developer';

import 'package:book_app/Bloc/BlocHomeScreen.dart';
import 'package:book_app/Event/EventHomeScreen.dart';
import 'package:book_app/State/StateHomeScreen.dart';
import 'package:book_app/Styling/TextStyling.dart';
import 'package:book_app/Styling/colors.dart';
import 'package:book_app/model/book.dart';
import 'package:book_app/widgets/progressCircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Class to create a book Tile
class bigBookTile extends StatefulWidget {
  bigBookTile({@required this.book, Key key}) : super(key: key);

  //Some Variables Used to Display the content od the tile
  final Book book;

  @override
  _bigBookTileState createState() => _bigBookTileState();
}

class _bigBookTileState extends State<bigBookTile> {
  void _showBookFinishDialog(Book book, BuildContext blocContext) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Do you want to finish that Book"),
            actions: <Widget>[
              FlatButton(
                child: Text("Finish"),
                onPressed: () {
                  BlocProvider.of<BlocHomeScreen>(blocContext)
                      .add(EventBookFinished(myBook: book));
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("I am still reading"),
                onPressed: () {},
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 12.0,
          bottom: 12,
          left: 20,
          right: 20), //Outside Padding two separate
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(25)),
            border: Border.all(width: 1.5, color: MyColors.borderGrey),
            color: MyColors.backgroundGrey),
        padding: const EdgeInsets.all(10), //Inside Padding of Content
        child: Column(
          children: <Widget>[
            //Big Top Headline
            Text(
              widget.book.title,
              style: MyTextStyle.bigHeadline,
              textAlign: TextAlign.center,
            ),
            //Bar below
            Divider(
              color: Colors.black,
              thickness: 2,
              height: 25,
            ),
            //Column for Progress and both Buttons
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                //Progress Bar etc
                Container(
                  //color: Colors.red,
                  height: 210,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      CircularProgress(
                          animationDuration: Duration(milliseconds: 500),
                          backgroundColor: MyColors.progressNotColor,
                          foregroundColor: MyColors.progressDoneColor,
                          currentPage: widget.book.currentPage,
                          pages: widget.book.pages),
                      Container(
                        //color: Colors.blue,
                        width:
                            140, //Hard Coeded for Good Alignment of Gesture Detector
                        height: 160,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) => Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          Align(
                                            child: FlatButton(
                                              child: Text("Finish"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                          ),
                                          Expanded(
                                            child: CupertinoPicker(
                                              scrollController:
                                                  FixedExtentScrollController(
                                                      initialItem: widget.book
                                                              .currentPage -
                                                          1),
                                              itemExtent:
                                                  40, //Abstand zwischen items
                                              onSelectedItemChanged: (int i) {
                                                widget.book.currentPage = i + 1;
                                              }, //later
                                              children: <Widget>[
                                                for (int i = 1;
                                                    i <= widget.book.pages;
                                                    ++i)
                                                  Center(
                                                      child: Text(
                                                    "$i",
                                                    style:
                                                        MyTextStyle.bigHeadline,
                                                  )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )).then((val) {
                              //Bottom Sheet Closed
                              if (widget.book.currentPage ==
                                  widget.book.pages) {
                                //If book finished ask if really wants to finish book
                                _showBookFinishDialog(widget.book, context);
                              }
                              //If book not finished simply update
                              else {
                                BlocProvider.of<BlocHomeScreen>(context)
                                    .add(EventBookUpdate(myBook: widget.book));
                                setState(() {});
                              }
                            }); //After Closed Call Bloc and Update Screen
                          },
                        ),
                      )
                    ],
                  ),
                ),
                //Minus Button
                Align(
                  alignment: Alignment.bottomLeft,
                  child: RaisedButton(
                      onPressed: () {
                        if (widget.book.currentPage > 1) {
                          widget.book.currentPage--;
                          BlocProvider.of<BlocHomeScreen>(context)
                              .add(EventBookUpdate(myBook: widget.book));
                          setState(() {});
                        }
                      },
                      child: Text(
                        "-",
                        style: MyTextStyle.iconStyle,
                      ),
                      shape: CircleBorder()),
                ),
                //Plus Button
                Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                      onPressed: () {
                        if (widget.book.currentPage == widget.book.pages - 1) {
                          _showBookFinishDialog(widget.book, context);
                        } else if (widget.book.currentPage <
                            widget.book.pages) {
                          widget.book.currentPage++;
                          BlocProvider.of<BlocHomeScreen>(context)
                              .add(EventBookUpdate(myBook: widget.book));
                          setState(() {});
                        }
                      },
                      child: Text(
                        "+",
                        style: MyTextStyle.iconStyle,
                      ),
                      shape: CircleBorder()),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:math';

void main() {
  runApp(MyApp());
  Fluttertoast.showToast(
    msg: 'Match all the cards!',
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Letter Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MatchLetterGame(),
    );
  }
}

class MatchLetterGame extends StatefulWidget {
  @override
  _MatchLetterGameState createState() => _MatchLetterGameState();
}

class _MatchLetterGameState extends State<MatchLetterGame> {
  List<String> letters = ['A', 'A', 'B', 'B', 'C', 'C', 'D', 'D', 'E', 'E', 'F', 'F', 'G', 'G', 'H', 'H'];
  List<bool> flipped = List<bool>.filled(16, false);
  List<int> cardIndices = [];
  int? firstCardIndex;
  int? secondCardIndex;
  int matchesCount = 0;

  @override
  void initState() {
    super.initState();
    cardIndices = List.generate(16, (index) => index);
    cardIndices.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Letter Game'),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 4,
          children: List.generate(16, (index) => CardWidget(
            letter: letters[cardIndices[index]],
            isFlipped: flipped[index],
            onTap: () => _handleCardTap(index),
          )),
        ),
      ),
    );
  }

  void _handleCardTap(int index) {
    setState(() {
      if (!flipped[index]) {
        flipped[index] = true;
        if (firstCardIndex == null) {
          firstCardIndex = index;
        } else {
          secondCardIndex = index;
          if (letters[cardIndices[firstCardIndex!]] != letters[cardIndices[secondCardIndex!]]) {
            // Wait for a short duration and then flip back the unmatched cards
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                flipped[firstCardIndex!] = false;
                flipped[secondCardIndex!] = false;
                firstCardIndex = null;
                secondCardIndex = null;
              });
            });
          } else {
            matchesCount++;
            if (matchesCount == 8) {
              _showWinPopup();
            }
            firstCardIndex = null;
            secondCardIndex = null;
          }
        }
      }
    });
  }

  void _showWinPopup() {
    Fluttertoast.showToast(
      msg: 'Congratulations! You won!',
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}

class CardWidget extends StatelessWidget {
  final String letter;
  final bool isFlipped;
  final Function onTap;

  const CardWidget({
    required this.letter,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      flipOnTouch: false,
      front: GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(
          margin: EdgeInsets.all(4.0),
          color: isFlipped ? Colors.white : Colors.blue,
          child: Center(
            child: Text(
              letter,
              style: TextStyle(fontSize: 40.0, color: isFlipped ? Colors.blue : Colors.white),
            ),
          ),
        ),
      ),
      back: Container(
        margin: EdgeInsets.all(4.0),
        color: Colors.white,
      ),
    );
  }
}

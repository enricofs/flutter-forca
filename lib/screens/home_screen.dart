import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_hangman/components/action_button.dart';
import 'package:flutter_hangman/utilities/hangman_words.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  final HangmanWords hangmanWords = HangmanWords();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    widget.hangmanWords.readWords();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 10.0),
                child: Text(
                  'JOGO DA FORCA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 58.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3.0,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 10.0),
                child: Text(
                  'ENRICO FERREIRA DOS SANTOS - 1431432312012',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 15.0),
                child: Image.asset(
                  'images/home-image.png',
                  height: height * 0.37,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Center(
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 64,
                      child: ActionButton(
                        buttonTitle: 'INICIAR',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameScreen(
                                hangmanObject: widget.hangmanWords,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 18.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

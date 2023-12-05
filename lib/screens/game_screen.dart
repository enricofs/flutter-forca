import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hangman/screens/home_screen.dart';
import 'package:flutter_hangman/utilities/alphabet.dart';
import 'package:flutter_hangman/components/word_button.dart';
import 'package:flutter_hangman/utilities/constants.dart';
import 'package:flutter_hangman/utilities/hangman_words.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.hangmanObject});

  final HangmanWords hangmanObject;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int lives = 5;
  int errors = 0;
  Alphabet englishAlphabet = Alphabet();
  late String word;
  late String hiddenWord;
  List<String> wordList = [];
  List<int> hintLetters = [];
  late List<bool> buttonStatus;
  late bool hintStatus;
  int hangState = 0;

  bool finishedGame = false;
  bool resetGame = false;

  Widget createButton(index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 6.0),
      child: Center(
        child: WordButton(
          buttonTitle: englishAlphabet.alphabet[index].toUpperCase(),
          onPress: buttonStatus[index] ? () => wordPress(index) : () {},
        ),
      ),
    );
  }

  void returnHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      ModalRoute.withName('homePage'),
    );
  }

  void initWords() {
    finishedGame = false;
    resetGame = false;
    hintStatus = true;
    hangState = 0;
    errors = 0; // Reiniciando o contador de erros específico para cada palavra
    buttonStatus = List.generate(26, (index) {
      return true;
    });
    wordList = [];
    hintLetters = [];
    word = widget.hangmanObject.getWord();
    if (word.isNotEmpty) {
      hiddenWord = widget.hangmanObject.getHiddenWord(word.length);
    } else {
      returnHomePage();
    }

    for (int i = 0; i < word.length; i++) {
      wordList.add(word[i]);
      hintLetters.add(i);
    }
  }

  void wordPress(int index) {
    if (lives == 0) {
      returnHomePage();
    }

    if (finishedGame) {
      setState(() {
        resetGame = true;
      });
      return;
    }

    bool check = false;
    setState(() {
      for (int i = 0; i < wordList.length; i++) {
        if (wordList[i] == englishAlphabet.alphabet[index]) {
          check = true;
          wordList[i] = '';
          hiddenWord = hiddenWord.replaceFirst(RegExp('_'), word[i], i);
        }
      }
      for (int i = 0; i < wordList.length; i++) {
        if (wordList[i] == '') {
          hintLetters.remove(i);
        }
      }
      if (!check) {
        hangState += 1;
        errors += 1; // Incrementando o contador de erros
      }

      if (hangState == 6) {
        finishedGame = true;
        lives -= 1;
        if (lives < 1) {
          Alert(
              style: kGameOverAlertStyle,
              context: context,
              title: "FIM DE JOGO!",
              desc: "Você perdeu...",
              buttons: [
                DialogButton(
                  color: kDialogButtonColor,
                  onPressed: () => returnHomePage(),
                  child: Icon(
                    MdiIcons.home,
                    size: 30.0,
                  ),
                ),
                DialogButton(
                  onPressed: () {
                    newGame();
                    Navigator.pop(context);
                  },
                  color: kDialogButtonColor,
                  child: Icon(MdiIcons.refresh, size: 30.0),
                ),
              ]).show();
        } else {
          Alert(
            context: context,
            style: kFailedAlertStyle,
            type: AlertType.error,
            title: word,
            buttons: [
              DialogButton(
                radius: BorderRadius.circular(10),
                width: 127,
                color: kDialogButtonColor,
                height: 52,
                child: Icon(
                  MdiIcons.arrowRightThick,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    initWords();
                  });
                },
              ),
            ],
          ).show();
        }
      }

      buttonStatus[index] = false;
      if (hiddenWord == word) {
        finishedGame = true;
        Alert(
          context: context,
          style: kSuccessAlertStyle,
          type: AlertType.success,
          title: word,
          buttons: [
            DialogButton(
              radius: BorderRadius.circular(10),
              width: 127,
              color: kDialogButtonColor,
              height: 52,
              child: Icon(
                MdiIcons.arrowRightThick,
                size: 30.0,
              ),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  initWords();
                });
              },
            )
          ],
        ).show();
      }
    });
  }

  void newGame() {
    setState(() {
      lives = 5;
      initWords();
    });
  }

  @override
  void initState() {
    super.initState();
    initWords();
  }

  @override
  Widget build(BuildContext context) {
    if (resetGame) {
      setState(() {
        initWords();
      });
    }
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 35.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(top: 0.5),
                                      child: IconButton(
                                        tooltip: 'Vidas',
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        iconSize: 39,
                                        icon: Icon(MdiIcons.heart),
                                        onPressed: () {},
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.7, 7.9, 0, 0.8),
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 38,
                                        width: 38,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              lives.toString() == "1"
                                                  ? "I"
                                                  : lives.toString(),
                                              style: const TextStyle(
                                                color: Color(0xFF2C1E68),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'PatrickHand',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              child: Text(
                                'Erros: $errors', // Adicionando contador de erros
                                style: kWordCounterTextStyle,
                              ),
                            ),
                            SizedBox(
                              child: IconButton(
                                tooltip: 'Dica',
                                iconSize: 39,
                                icon: Icon(MdiIcons.lightbulb),
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: hintStatus
                                    ? () {
                                        int rand = Random()
                                            .nextInt(hintLetters.length);
                                        wordPress(englishAlphabet.alphabet
                                            .indexOf(
                                                wordList[hintLetters[rand]]));
                                        hintStatus = false;
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.asset(
                              'images/$hangState.png',
                              height: 1001,
                              width: 991,
                              gaplessPlayback: true,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 35.0),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              hiddenWord,
                              style: kWordTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 2.0, 8.0, 10.0),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: createButton(0),
                      ),
                      TableCell(
                        child: createButton(1),
                      ),
                      TableCell(
                        child: createButton(2),
                      ),
                      TableCell(
                        child: createButton(3),
                      ),
                      TableCell(
                        child: createButton(4),
                      ),
                      TableCell(
                        child: createButton(5),
                      ),
                      TableCell(
                        child: createButton(6),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(7),
                      ),
                      TableCell(
                        child: createButton(8),
                      ),
                      TableCell(
                        child: createButton(9),
                      ),
                      TableCell(
                        child: createButton(10),
                      ),
                      TableCell(
                        child: createButton(11),
                      ),
                      TableCell(
                        child: createButton(12),
                      ),
                      TableCell(
                        child: createButton(13),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(14),
                      ),
                      TableCell(
                        child: createButton(15),
                      ),
                      TableCell(
                        child: createButton(16),
                      ),
                      TableCell(
                        child: createButton(17),
                      ),
                      TableCell(
                        child: createButton(18),
                      ),
                      TableCell(
                        child: createButton(19),
                      ),
                      TableCell(
                        child: createButton(20),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(21),
                      ),
                      TableCell(
                        child: createButton(22),
                      ),
                      TableCell(
                        child: createButton(23),
                      ),
                      TableCell(
                        child: createButton(24),
                      ),
                      TableCell(
                        child: createButton(25),
                      ),
                      const TableCell(
                        child: Text(''),
                      ),
                      const TableCell(
                        child: Text(''),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:fyp_translation_apps/pages/HomePage.dart';
import 'package:unicons/unicons.dart';
import 'package:clipboard/clipboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:fyp_translation_apps/pages/word.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';

import 'home.dart';

class Translation extends StatefulWidget {
  const Translation({super.key});

  @override
  State<Translation> createState() => _TranslationState();
}

typedef Future<Null> Action();

class _TranslationState extends State<Translation> {
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  final List<String> Sourcelanguage = <String>[
    'Chinese',
    'English',
    'Japanese',
    'French',
    'German',
    'Korean',
    'Dutch',
    'Spanish',
    'Polish',
    'Russian',
  ];
  final List<String> Destlanguage = <String>[
    'Chinese',
    'English',
    'Japanese',
    'French',
    'German',
    'Korean',
    'Dutch',
    'Spanish',
    'Polish',
    'Russian',
  ];
  String SourceselectedValue = 'Chinese';
  String DestselectedValue = 'English';
  Map<String, Map<String, String>> sourcemap = <String, Map<String, String>>{
    'Chinese': {
      //'tts': 'zh',
      'google': 'zh-tw',
      'stt': 'zh-HK',
    },
    'English': {
      //'tts': 'en',
      'google': 'en',
      'stt': 'en-US',
    },
    'Japanese': {
      //'tts': 'ja',
      'google': 'ja',
      'stt': 'ja-JP',
    },
    'French': {
      //'tts': 'ja',
      'google': 'fr',
      'stt': 'fr-FR',
    },
    'German': {
      //'tts': 'ja',
      'google': 'de',
      'stt': 'de-DE',
    },
    'Korean': {
      //'tts': 'ja',
      'google': 'ko',
      'stt': 'ko-KR',
    },
    'Dutch': {
      //'tts': 'ja',
      'google': 'nl',
      'stt': 'nl-NL',
    },
    'Spanish': {
      //'tts': 'ja',
      'google': 'es',
      'stt': 'es-ES',
    },
    'Polish': {
      //'tts': 'ja',
      'google': 'pl',
      'stt': 'pl-PL',
    },
    'Russian': {
      //'tts': 'ja',
      'google': 'ru',
      'stt': 'ru-RU',
    },
  };
  Map<String, Map<String, String>> destmap = <String, Map<String, String>>{
    'Chinese': {
      'tts': 'zh-HK',
      'google': 'zh-tw',
      //'stt': 'zh-HK',
    },
    'English': {
      'tts': 'en-US',
      'google': 'en',
      //'stt': 'en-US',
    },
    'Japanese': {
      'tts': 'ja-JP',
      'google': 'ja',
      //'stt': 'ja-JP',
    },
    'French': {
      'tts': 'fr-FR',
      'google': 'fr',
      //'stt': 'fr-FR',
    },
    'German': {
      'tts': 'de-DE',
      'google': 'de',
      //'stt': 'de-DE',
    },
    'Korean': {
      'tts': 'ko-KR',
      'google': 'ko',
      //'stt': 'ko-KR',
    },
    'Dutch': {
      'tts': 'nl-NL',
      'google': 'nl',
      //'stt': 'nl-NL',
    },
    'Spanish': {
      'tts': 'es-ES',
      'google': 'es',
      //'stt': 'es-ES',
    },
    'Polish': {
      'tts': 'pl-PL',
      'google': 'pl',
      //'stt': 'pl-PL',
    },
    'Russian': {
      'tts': 'ru-RU',
      'google': 'ru',
      //'stt': 'ru-RU',
    },
  };
  String translated = '';
  TextEditingController sourceTextEditingController = TextEditingController();
  TextEditingController destTextEditingController = TextEditingController();
  String pasteValue = '';
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  List<Word> lastWords = [];
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<String> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  Random random = Random();
  List<Widget> wordWidgets = [];
  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = Sourcelanguage;

      //var systemLocale = await speech.systemLocale();
      _currentLocaleId = sourcemap[SourceselectedValue]!['stt']!;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  final FlutterTts flutterTts = FlutterTts();

  speak(String text) async {
    await flutterTts.setLanguage(destmap[DestselectedValue]!['tts']!);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation'),
        actions: [
          IconButton(
            onPressed: () {
              hawkFabMenuController.toggleMenu();
            },
            icon: const Icon(Icons.replay_outlined),
          ),
        ],
      ),
      body: HawkFabMenu(
        icon: AnimatedIcons.menu_arrow,
        fabColor: Colors.yellow,
        iconColor: Colors.green,
        hawkFabMenuController: hawkFabMenuController,
        items: [
          HawkFabMenuItem(
            label: 'HomePage',
            ontap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Go To Homepage')),
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ));
            },
            icon: const Icon(Icons.home),
            color: Colors.red,
            labelColor: Colors.blue,
            labelBackgroundColor: Colors.white,
          ),
          HawkFabMenuItem(
            label: 'OCR',
            ontap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Go To OCR')),
              );
            },
            icon: const Icon(UniconsLine.camera_plus),
            labelColor: Colors.blue,
            labelBackgroundColor: Colors.white,
          ),
          HawkFabMenuItem(
            label: 'Conversation',
            color: Colors.purple,
            ontap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu 3 selected')),
              );
            },
            icon: const Icon(UniconsLine.comments_alt),
            labelColor: Colors.blue,
            labelBackgroundColor: Colors.white,
          ),
        ],
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 30),
                            height: size.height * 0.07,
                            width: size.width * 0.4,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                items: Sourcelanguage.map(
                                    (item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )).toList(),
                                value: SourceselectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    SourceselectedValue = value!;
                                    _switchLang(sourcemap[SourceselectedValue]![
                                        'stt']!);
                                    translate(sourceTextEditingController.text);
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                iconSize: 14,
                                iconEnabledColor: Colors.yellow,
                                iconDisabledColor: Colors.grey,
                                buttonHeight: 50,
                                buttonWidth: 160,
                                buttonPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.blueAccent,
                                ),
                                buttonElevation: 2,
                                itemHeight: 40,
                                itemPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                dropdownMaxHeight: 200,
                                dropdownWidth: 200,
                                dropdownPadding: null,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.blueAccent,
                                ),
                                dropdownElevation: 8,
                                scrollbarRadius: const Radius.circular(40),
                                scrollbarThickness: 6,
                                scrollbarAlwaysShow: true,
                                offset: const Offset(-20, 0),
                              ),
                            ),
                          ),
                          const Icon(UniconsLine.exchange_alt,
                              size: 30, color: Colors.blue),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 30),
                            height: size.height * 0.07,
                            width: size.width * 0.4,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                items: Destlanguage.map(
                                    (item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )).toList(),
                                value: DestselectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    DestselectedValue = value!;
                                    translate(sourceTextEditingController.text);
                                  });
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                iconSize: 14,
                                iconEnabledColor: Colors.yellow,
                                iconDisabledColor: Colors.grey,
                                buttonHeight: 50,
                                buttonWidth: 160,
                                buttonPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.blueAccent,
                                ),
                                buttonElevation: 2,
                                itemHeight: 40,
                                itemPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                dropdownMaxHeight: 200,
                                dropdownWidth: 200,
                                dropdownPadding: null,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.blueAccent,
                                ),
                                dropdownElevation: 8,
                                scrollbarRadius: const Radius.circular(40),
                                scrollbarThickness: 6,
                                scrollbarAlwaysShow: true,
                                offset: const Offset(-20, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const <Widget>[
                          Text("From", style: TextStyle(fontSize: 25.0)),
                        ],
                      ),
                      /*Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),*/
                      TextField(
                        controller: sourceTextEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        maxLength: 128,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: const InputDecoration(
                            hintText: "Enter Text",
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.greenAccent), //<-- SEE HERE
                              //borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.blueAccent))),
                        onChanged: (text) {
                          translate(sourceTextEditingController.text);
                          /*TextSelection previousSelection =
                            sourceTextEditingController.selection;
                        sourceTextEditingController.text = text;
                        sourceTextEditingController.selection =
                            previousSelection;*/
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.blue, Colors.blueAccent],
                              ),
                            ),
                            child: MaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: StadiumBorder(),
                              onPressed: () {
                                setState(() {
                                  wordWidgets.clear();
                                  sourceTextEditingController.clear();
                                  destTextEditingController.clear();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Icon(
                                      UniconsLine.times,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 1),
                                    ),
                                    const Text(
                                      'Clear',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.blue, Colors.blueAccent],
                              ),
                            ),
                            child: MaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: StadiumBorder(),
                              onPressed: () {
                                FlutterClipboard.paste().then((value) {
                                  // Do what ever you want with the value.
                                  setState(() {
                                    if (sourceTextEditingController
                                            .text.length >
                                        0) {
                                      var cursorPos =
                                          sourceTextEditingController
                                              .selection.base.offset;
                                      String suffixText =
                                          sourceTextEditingController.text
                                              .substring(cursorPos);
                                      int length = value.length;
                                      String prefixText =
                                          sourceTextEditingController.text
                                              .substring(0, cursorPos);
                                      sourceTextEditingController.text =
                                          prefixText + value + suffixText;
                                      sourceTextEditingController.selection =
                                          TextSelection(
                                        baseOffset: cursorPos + length,
                                        extentOffset: cursorPos + length,
                                      );
                                      translate(
                                          sourceTextEditingController.text);
                                    } else {
                                      sourceTextEditingController.text = value;
                                      sourceTextEditingController.value =
                                          sourceTextEditingController.value
                                              .copyWith(
                                        text: value,
                                        selection: TextSelection.fromPosition(
                                          TextPosition(offset: value.length),
                                        ),
                                      );
                                      translate(
                                          sourceTextEditingController.text);
                                    }
                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Icon(
                                      UniconsLine.file_copy_alt,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 1),
                                    ),
                                    const Text(
                                      'Paste',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const <Widget>[
                          Text("To", style: TextStyle(fontSize: 25.0)),
                        ],
                      ),
                      /*Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),*/
                      TextField(
                        controller: destTextEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        readOnly: true,
                        //maxLength: 128,
                        decoration: const InputDecoration(
                            //hintText: "Enter Remarks",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.greenAccent), //<-- SEE HERE
                              //borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.greenAccent))),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      /*OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(UniconsLine.star),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.0, color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: Text("Translate"),
                        ),*/
                      /*GestureDetector(
                      onTap: () {
                        if (_hasSpeech) {
                          if (speech.isListening) {
                            stopListening();
                          } else {
                            startListening();
                          }
                        }
                      },
                      child: Container(
                          height: size.height * 0.1,
                          width: size.width * 0.2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0,
                                  spreadRadius: level * 1.5,
                                  color: Colors.red.withOpacity(0.5))
                            ],
                            color: speech.isListening ? Colors.red : Colors.red,
                            // border: Border.all(
                            //   color: Colors.black26,
                            //   width: 1,
                            //   style: speech.isListening ? BorderStyle.none : BorderStyle.solid,
                            // ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Icon(
                            Icons.mic,
                            size: 40,
                            color: !speech.isListening
                                ? Colors.white
                                : Colors.white,
                          )),
                    ),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.blue, Colors.blueAccent],
                              ),
                            ),
                            child: MaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: StadiumBorder(),
                              onPressed: () {
                                setState(() {
                                  speak(destTextEditingController.text);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Icon(
                                      UniconsLine.volume,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_hasSpeech) {
                                if (speech.isListening) {
                                  stopListening();
                                } else {
                                  startListening();
                                }
                              }
                            },
                            child: Container(
                                height: size.height * 0.1,
                                width: size.width * 0.2,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 0,
                                        spreadRadius: level * 1.5,
                                        color: Colors.red.withOpacity(0.5))
                                  ],
                                  color: speech.isListening
                                      ? Colors.red
                                      : Colors.red,
                                  // border: Border.all(
                                  //   color: Colors.black26,
                                  //   width: 1,
                                  //   style: speech.isListening ? BorderStyle.none : BorderStyle.solid,
                                  // ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                                child: Icon(
                                  Icons.mic,
                                  size: 40,
                                  color: !speech.isListening
                                      ? Colors.white
                                      : Colors.white,
                                )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.blue, Colors.blueAccent],
                              ),
                            ),
                            child: MaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: StadiumBorder(),
                              onPressed: () {
                                setState(() {
                                  wordWidgets.clear();
                                  sourceTextEditingController.clear();
                                  destTextEditingController.clear();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Icon(
                                      UniconsLine.star,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                      )
                      /*GestureDetector(
                      onTap: () {
                        if (_hasSpeech) {
                          if (speech.isListening) {
                            stopListening();
                          } else {
                            startListening();
                          }
                        }
                      },
                      child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0,
                                  spreadRadius: level * 1.5,
                                  color: Colors.red.withOpacity(0.5))
                            ],
                            color: speech.isListening ? Colors.red : Colors.red,
                            // border: Border.all(
                            //   color: Colors.black26,
                            //   width: 1,
                            //   style: speech.isListening ? BorderStyle.none : BorderStyle.solid,
                            // ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Icon(
                            Icons.mic,
                            size: 40,
                            color: !speech.isListening
                                ? Colors.white
                                : Colors.white,
                          )),
                    ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startListening() {
    lastWords.clear();
    //actionQueue.clear();
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 60),
        pauseFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        // onDevice: true,
        listenMode: ListenMode.deviceDefault);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    //textEditingController.text = speech.lastRecognizedWords;
    //print(textEditingController.text);
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    print('cancel');
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      var words = result.recognizedWords.split(' ');
      if (words.length > 0 && words[0].isNotEmpty) {
        List<Word> ww = [];
        for (var i = 0; i < words.length; i++) {
          if (i >= lastWords.length) {
            print(words[i]);
            var word = Word(words[i]);
            ww.add(word);
            print(word);
            lastWords.add(word);
            //textEditingController.text = word.value;
            /*var cursorPos = textEditingController.selection.base.offset;
            String suffixText = textEditingController.text.substring(cursorPos);
            int length = word.value.length;
            String prefixText =
                textEditingController.text.substring(0, cursorPos);
            textEditingController.text = prefixText + word.value + suffixText;
            textEditingController.selection = TextSelection(
              baseOffset: cursorPos + length,
              extentOffset: cursorPos + length,
            );*/
            if (sourceTextEditingController.text.length > 0) {
              var cursorPos = sourceTextEditingController.selection.base.offset;
              String suffixText =
                  sourceTextEditingController.text.substring(cursorPos);
              int length = word.value.length;
              String prefixText =
                  sourceTextEditingController.text.substring(0, cursorPos);
              sourceTextEditingController.text =
                  prefixText + word.value + suffixText;
              sourceTextEditingController.selection = TextSelection(
                baseOffset: cursorPos + length,
                extentOffset: cursorPos + length,
              );
              translate(sourceTextEditingController.text);
            } else {
              sourceTextEditingController.text = word.value;
              sourceTextEditingController.value =
                  sourceTextEditingController.value.copyWith(
                text: word.value,
                selection: TextSelection.fromPosition(
                  TextPosition(offset: word.value.length),
                ),
              );
              translate(sourceTextEditingController.text);
            }
          }
        }
        //if (ww.length > 0) _addToQueue(ww);
      }

      // print("@ ${result.recognizedWords}=>$last");
      // if (last.isNotEmpty && lastWords.length == 0 || lastWords.last.value != last) {
      //   print(last);
      //   lastWords.add(Word(last, random));
      // }
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
      print(lastError);
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
      print(lastStatus);
      level = 0.0;
    });
  }

  void _switchLang(String selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  void translate(text) async {
    //const apiKey = 'AIzaSyCkVgDjHggIJQrtvyMpJfaYQAVnAnK9uEQ';
    String to = destmap[DestselectedValue]!['google']!;
    String src = sourcemap[SourceselectedValue]!['google']!;
    final url = Uri.parse(
      'https://translate.eugene-lam.hk?dest=$to&text=$text&src=$src',
    );
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      print(response);
      final body = json.decode(response.body);
      print(body);
      final tranlations = body['translated_text'];
      print(tranlations);
      translated = body['translated_text'] ?? "";
      print(translated);
      setState(() {
        destTextEditingController.text = translated;
      });
    }
  }
}

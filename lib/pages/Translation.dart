import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:unicons/unicons.dart';
import 'package:clipboard/clipboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Translation extends StatefulWidget {
  const Translation({super.key});

  @override
  State<Translation> createState() => _TranslationState();
}

class _TranslationState extends State<Translation> {
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
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Cityu Translation!"),
      ),
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
                          height: size.height * 0.05,
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
                          height: size.height * 0.05,
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
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    TextField(
                      controller: sourceTextEditingController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      maxLength: 128,
                      decoration: const InputDecoration(
                          hintText: "Enter Text",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Colors.greenAccent), //<-- SEE HERE
                            //borderRadius: BorderRadius.circular(50.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.redAccent))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              sourceTextEditingController.text = "";
                              destTextEditingController.text = "";
                            });
                          },
                          icon: Icon(UniconsLine.times),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.0, color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: Text("Clear"),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            FlutterClipboard.paste().then((value) {
                              // Do what ever you want with the value.
                              setState(() {
                                sourceTextEditingController.text = value;
                                pasteValue = value;
                              });
                            });
                          },
                          icon: Icon(UniconsLine.file_copy_alt),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.0, color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: Text("Paste"),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        Text("Destination", style: TextStyle(fontSize: 25.0)),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
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
                                  width: 1, color: Colors.redAccent))),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          translate(sourceTextEditingController.text);
                        });
                      },
                      icon: Icon(UniconsLine.english_to_chinese),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      label: Text("Translate"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

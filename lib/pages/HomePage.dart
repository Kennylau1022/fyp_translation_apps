import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fyp_translation_apps/data.dart';

import 'home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        /*const Positioned.fill(  //
            child: Image(
              image: AssetImage('assets/cloud.jpg'),
              fit : BoxFit.fill,
           ),
          ), */
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      height: size.height * .25,
                      child: Swiper(
                        itemCount: 3,
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                                image: AssetImage(images1[index]),
                                fit: BoxFit.cover),
                          );
                        },
                        viewportFraction: 0.8,
                        scale: 0.9,
                        pagination: const SwiperPagination(),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text("Function", style: TextStyle(fontSize: 25.0)),
                  ],
                ),
                Expanded(
                  child: GridView.count(
                    //padding: const EdgeInsets.all(10),
                    padding: EdgeInsets.all(10.0),
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 20.0,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BPage(),
                                ));
                          },
                          child: Center(
                            child: Column(
                              children: const <Widget>[
                                Icon(UniconsLine.english_to_chinese,
                                    size: 80, color: Colors.blue),
                                Text("Translation",
                                    style: TextStyle(fontSize: 15.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 20.0,
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: Column(
                              children: const <Widget>[
                                Icon(UniconsLine.file_info_alt,
                                    size: 80, color: Colors.red),
                                Text("Full Translation",
                                    style: TextStyle(fontSize: 15.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 20.0,
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: Column(
                              children: const <Widget>[
                                Icon(UniconsLine.camera,
                                    size: 80, color: Colors.green),
                                Text("Image To Text",
                                    style: TextStyle(fontSize: 15.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 20.0,
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: Column(
                              children: const <Widget>[
                                Icon(UniconsLine.comments_alt,
                                    size: 80, color: Colors.purple),
                                Text("Conversation",
                                    style: TextStyle(fontSize: 15.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

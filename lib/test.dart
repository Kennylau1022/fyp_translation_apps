import 'pages/home.dart';
import 'package:flutter/material.dart';

class DX extends StatelessWidget {
  const DX({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35), //* you can  increase it
          child: Card(
            color: Colors
                .transparent, //* or set the bg Color and remove [ClipRRect]
            child: Container(
              width: 400,
              height: 100,
              // margin: EdgeInsets.all(5),

              decoration: BoxDecoration(
               border: Border.all(width: 0, color: Colors.transparent),
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    // cardBorderColor,
                    Theme.of(context).colorScheme.surface,
                  ],
                  stops: [0, 0.8],
                ),
              ),
              child: Center(child: Text("asdasd")),
            ),
          ),
        ),
      ),
    );
  }
}
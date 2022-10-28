import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CPage extends StatefulWidget {
  const CPage({super.key});

  @override
  State<CPage> createState() => _CPageState();
}

class _CPageState extends State<CPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      
      body: _CPage(),
    );
  }
}

class _CPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('我是C'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
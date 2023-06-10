// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0e1116),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GridPaper(
          color: Color.fromARGB(255, 55, 66, 79),
          interval: 100,
          divisions: 1,
          subdivisions: 2,
          child: Column(children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [],
              ),
            )
          ]),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 55, 66, 79),
        ),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [],
        ),
      ),
    );
  }
}

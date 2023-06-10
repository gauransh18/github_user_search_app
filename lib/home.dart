// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grid_paper/grid_paper.dart';
import 'constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: DotMatrixPaper(
              gridUnitSize: 25,
              originAlignment: Alignment.center,
              background: backgroundColor, // const Color(0xFF444444),
              style: const DotMatrixStyle.standard().copyWith(
                dotColor: dotColor,
                divider: DotMatrixDivider.biggerDot,
                dividerColor: dotColor,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: height * 0.3,
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        'assets/main.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      height: 60,
                      width: width - 40,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: GoogleFonts.abel(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'username',
                                hintStyle: GoogleFonts.abel(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 22,
                                ),
                                contentPadding: EdgeInsets.all(12),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Perform search here
                            },
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),

      //BOTTOM SHEET

      // bottomSheet: Container(
      //   decoration: BoxDecoration(
      //     color: Color.fromARGB(255, 55, 66, 79),

      //   ),
      //   height: MediaQuery.of(context).size.height * 0.1,
      //   width: MediaQuery.of(context).size.width,
      //   child: Row(
      //     children: [],
      //   ),
      // ),
    );
  }
}

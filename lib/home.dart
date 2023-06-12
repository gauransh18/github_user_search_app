// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grid_paper/grid_paper.dart';
import 'package:dio/dio.dart';
import 'constants.dart';
import 'dart:convert';
import 'details.dart';

class GitHubUser {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;

  GitHubUser({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.htmlUrl,
  });
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController usernameController = TextEditingController();
  List<GitHubUser> users = [];
  bool searched = false;

  Future<void> getUsers(String username) async {
    try {
      Dio dio = Dio();
      Response response =
          await dio.get('https://api.github.com/search/users?q=$username');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.toString());
        List<dynamic> items = data['items'];

        List<GitHubUser> userList = items.map((item) {
          return GitHubUser(
            login: item['login'],
            id: item['id'],
            avatarUrl: item['avatar_url'],
            htmlUrl: item['html_url'],
          );
        }).toList();

        setState(() {
          users = userList;
          searched = true;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Request Failed'),
              content: Text(
                  'Error code: ${response.statusCode}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
     // print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Network Error'),
            content: Text('Please check your network access.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void clearSearch() {
    setState(() {
      searched = false;
      users.clear();
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: searched
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  clearSearch();
                },
              )
            : null,
      ),
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: DotMatrixPaper(
              gridUnitSize: 25,
              originAlignment: Alignment.center,
              background: backgroundColor,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        'assets/main.gif',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: TextField(
                                controller: usernameController,
                                autocorrect: false,
                                cursorColor: Colors.white,
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter Username',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 18,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (value) {
                                  String githubUser =
                                      usernameController.text.trim();
                                  if (githubUser.isNotEmpty) {
                                    getUsers(githubUser);
                                  }
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              String githubUser =
                                  usernameController.text.trim();
                              if (githubUser.isNotEmpty) {
                                getUsers(githubUser);
                              }
                            },
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (users.isEmpty && searched)
                    Container(
                      padding: EdgeInsets.all(8),
                      height: height * 0.6,
                      width: width - 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: dotColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'No users found',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (users.isNotEmpty)
                    Container(
                      height: height * 0.6,
                      width: width - 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: dotColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(8, 20, 8, 12),
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: ListTile(
                              onTap: () {
                                GitHubUser user = users[index];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserDetails(user: user),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(users[index].avatarUrl),
                              ),
                              title: Text(
                                users[index].login,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

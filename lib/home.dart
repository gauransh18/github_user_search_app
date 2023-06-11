// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:grid_paper/grid_paper.dart';
// import 'package:dio/dio.dart';
// import 'constants.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'dart:convert';
// import 'details.dart';

// class GitHubUser {
//   final String login;
//   final int id;
//   final String avatarUrl;
//   final String htmlUrl;

//   GitHubUser({
//     required this.login,
//     required this.id,
//     required this.avatarUrl,
//     required this.htmlUrl,
//   });
// }

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   TextEditingController usernameController = TextEditingController();
//   List<GitHubUser> users = [];
//   bool searched = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> getUsers(String username) async {
//     try {
//       Dio dio = Dio();
//       Response response =
//           await dio.get('https://api.github.com/search/users?q=' + username);
//       Map<String, dynamic> data = json.decode(response.toString());
//       List<dynamic> items = data['items'];

//       List<GitHubUser> userList = items.map((item) {
//         return GitHubUser(
//           login: item['login'],
//           id: item['id'],
//           avatarUrl: item['avatar_url'],
//           htmlUrl: item['html_url'],
//         );
//       }).toList();

//       setState(() {
//         users = userList;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   void clearSearch() {
//     setState(() {
//       searched = false;
//       users.clear();
//     });
//   }

//   @override
//   void dispose() {
//     usernameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: searched
//             ? IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: () {
//                   clearSearch();
//                 },
//               )
//             : null,
//       ),
//       backgroundColor: backgroundColor,
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           SizedBox(
//             height: height,
//             width: width,
//             child: DotMatrixPaper(
//               gridUnitSize: 25,
//               originAlignment: Alignment.center,
//               background: backgroundColor,
//               style: const DotMatrixStyle.standard().copyWith(
//                 dotColor: dotColor,
//                 divider: DotMatrixDivider.biggerDot,
//                 dividerColor: dotColor,
//               ),
//             ),
//           ),
//           Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: AssetImage(
//                         'assets/main.png',
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Center(
//                     child: Container(
//                       height: 60,
//                       width: width - 40,
//                       decoration: BoxDecoration(
//                         color: backgroundColor,
//                         border: Border.all(
//                           color: Colors.white,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: usernameController,
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                               ),
//                               autocorrect: false,
//                               cursorColor: Colors.white,
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: 'username',
//                                 hintStyle: GoogleFonts.poppins(
//                                   color: Colors.white.withOpacity(0.6),
//                                   fontSize: 18,
//                                 ),
//                                 contentPadding: EdgeInsets.all(12),
//                               ),
//                               onSubmitted: (value) {
//                                 getUsers(value);
//                               },
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               getUsers(usernameController.text);
//                             },
//                             icon: Icon(
//                               Icons.search,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   if (searched)
//                     Container(
//                       height: height * 0.6,
//                       width: width - 40,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: dotColor,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListView.builder(
//                         itemCount: users.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage:
//                                   NetworkImage(users[index].avatarUrl),
//                             ),
//                             title: Text(users[index].login),
//                             onTap: () {
//                               // Open user profile in a web view or navigate to a new screen
//                               // using users[index].htmlUrl
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   // if (githubUser.isNotEmpty)
//                   //   Padding(
//                   //     padding: const EdgeInsets.all(20.0),
//                   //     child: Container(
//                   //       padding: EdgeInsets.all(20),
//                   //       height: height * 0.6,
//                   //       width: width - 40,
//                   //       decoration: BoxDecoration(
//                   //         border: Border.all(
//                   //           color: dotColor,
//                   //           width: 2,
//                   //         ),
//                   //         color: Colors.transparent,
//                   //         borderRadius: BorderRadius.circular(12),
//                   //       ),
//                   //       child: SingleChildScrollView(
//                   //         child: Column(
//                   //           children: [
//                   //             CircleAvatar(
//                   //               radius: 50,
//                   //               backgroundImage:
//                   //                   NetworkImage(githubUser[0].avatarUrl),
//                   //             ),
//                   //             SizedBox(height: 10),
//                   //             Text(
//                   //               githubUser[0].name,
//                   //               style: GoogleFonts.poppins(
//                   //                 color: Colors.white,
//                   //                 fontSize: 24,
//                   //                 fontWeight: FontWeight.bold,
//                   //               ),
//                   //             ),
//                   //             SizedBox(height: 10),
//                   //             Text(
//                   //               '@${githubUser[0].login}',
//                   //               style: GoogleFonts.poppins(
//                   //                 color: Colors.white,
//                   //                 fontSize: 18,
//                   //               ),
//                   //             ),
//                   //             SizedBox(height: 10),
//                   //             Row(
//                   //               mainAxisAlignment: MainAxisAlignment.center,
//                   //               children: [
//                   //                 Container(
//                   //                   height: 70,
//                   //                   padding: EdgeInsets.symmetric(
//                   //                     vertical: 8,
//                   //                     horizontal: 16,
//                   //                   ),
//                   //                   decoration: BoxDecoration(
//                   //                     color: dotColor,
//                   //                     borderRadius: BorderRadius.circular(12),
//                   //                   ),
//                   //                   child: Column(
//                   //                     children: [
//                   //                       Text(
//                   //                         githubUser[0].followers,
//                   //                         style: GoogleFonts.poppins(
//                   //                           color: Colors.white,
//                   //                           fontSize: 18,
//                   //                           fontWeight: FontWeight.bold,
//                   //                         ),
//                   //                       ),
//                   //                       SizedBox(height: 4),
//                   //                       Text(
//                   //                         'Followers',
//                   //                         style: GoogleFonts.poppins(
//                   //                           color:
//                   //                               Colors.white.withOpacity(0.6),
//                   //                           fontSize: 14,
//                   //                         ),
//                   //                       ),
//                   //                     ],
//                   //                   ),
//                   //                 ),
//                   //                 SizedBox(width: 20),
//                   //                 Container(
//                   //                   height: 70,
//                   //                   padding: EdgeInsets.symmetric(
//                   //                     vertical: 8,
//                   //                     horizontal: 16,
//                   //                   ),
//                   //                   decoration: BoxDecoration(
//                   //                     color: dotColor,
//                   //                     borderRadius: BorderRadius.circular(12),
//                   //                   ),
//                   //                   child: Column(
//                   //                     children: [
//                   //                       Text(
//                   //                         githubUser[0].following,
//                   //                         style: GoogleFonts.poppins(
//                   //                           color: Colors.white,
//                   //                           fontSize: 18,
//                   //                           fontWeight: FontWeight.bold,
//                   //                         ),
//                   //                       ),
//                   //                       SizedBox(height: 4),
//                   //                       Text(
//                   //                         'Following',
//                   //                         style: GoogleFonts.poppins(
//                   //                           color:
//                   //                               Colors.white.withOpacity(0.6),
//                   //                           fontSize: 14,
//                   //                         ),
//                   //                       ),
//                   //                     ],
//                   //                   ),
//                   //                 ),
//                   //               ],
//                   //             ),
//                   //             SizedBox(height: 10),
//                   //             Container(
//                   //               height: 70,
//                   //               padding: EdgeInsets.symmetric(
//                   //                 vertical: 8,
//                   //                 horizontal: 16,
//                   //               ),
//                   //               decoration: BoxDecoration(
//                   //                 color: dotColor,
//                   //                 borderRadius: BorderRadius.circular(12),
//                   //               ),
//                   //               child: Column(
//                   //                 children: [
//                   //                   Text(
//                   //                     githubUser[0].publicRepos,
//                   //                     style: GoogleFonts.poppins(
//                   //                       color: Colors.white,
//                   //                       fontSize: 18,
//                   //                       fontWeight: FontWeight.bold,
//                   //                     ),
//                   //                   ),
//                   //                   SizedBox(height: 4),
//                   //                   Text(
//                   //                     'Public Repos',
//                   //                     style: GoogleFonts.poppins(
//                   //                       color: Colors.white.withOpacity(0.6),
//                   //                       fontSize: 14,
//                   //                     ),
//                   //                   ),
//                   //                 ],
//                   //               ),
//                   //             ),
//                   //             SizedBox(height: 10),
//                   //             ElevatedButton(
//                   //                 onPressed: () {
//                   //                   Navigator.push(
//                   //                     context,
//                   //                     MaterialPageRoute(
//                   //                       builder: (context) =>
//                   //                           UserDetails(user: githubUser[0]),
//                   //                     ),
//                   //                   );
//                   //                 },
//                   //                 child: Text(
//                   //                   'View Details',
//                   //                   style: GoogleFonts.poppins(
//                   //                     color: Colors.white.withOpacity(0.6),
//                   //                     fontSize: 14,
//                   //                   ),
//                   //                 )),
//                   //           ],
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ).animate().slideY(
//                   //         delay: Duration(milliseconds: 100),
//                   //         begin: 1.0,
//                   //         end: 0,
//                   //         curve: Curves.easeOut,
//                   //         duration: Duration(
//                   //           milliseconds: 250,
//                   //         ),
//                   //       ),
//                   // if (githubUser.isEmpty && searched)
//                   //   Container(
//                   //     padding: EdgeInsets.all(20),
//                   //     height: height * 0.6,
//                   //     decoration: BoxDecoration(
//                   //       border: Border.all(
//                   //         color: dotColor,
//                   //         width: 2,
//                   //       ),
//                   //       color: Colors.transparent,
//                   //       borderRadius: BorderRadius.circular(12),
//                   //     ),
//                   //     child: Center(
//                   //       child: Text(
//                   //         'No user found.',
//                   //         style: GoogleFonts.poppins(
//                   //           color: Colors.white,
//                   //           fontSize: 18,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ).animate().slideY(
//                   //         begin: 1.0,
//                   //         end: 0,
//                   //         curve: Curves.easeOut,
//                   //         duration: Duration(
//                   //           milliseconds: 250,
//                   //         ),
//                   //       ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grid_paper/grid_paper.dart';
import 'package:dio/dio.dart';
import 'constants.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          await dio.get('https://api.github.com/search/users?q=' + username);
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
    } catch (e) {
      print(e);
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
                        'assets/main.png',
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
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search GitHub Username',
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
                    Text(
                      'No users found',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (users.isNotEmpty)
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
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                GitHubUser user =
                                    users[index]; // Retrieve the selected user
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserDetails(
                                        user:
                                            user), // Pass the GitHubUser object
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
                            );
                          },
                        ),
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

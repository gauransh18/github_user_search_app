import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grid_paper/grid_paper.dart';
import 'package:dio/dio.dart';
import 'constants.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GithubUser {
  final String login;
  final String name;
  final String publicRepos;
  final String followers;
  final String following;
  final String avatarUrl;

  GithubUser({
    required this.login,
    required this.avatarUrl,
    required this.name,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      avatarUrl: json['avatar_url'],
      login: json['login'],
      name: json['name'],
      publicRepos: json['public_repos'].toString(),
      followers: json['followers'].toString(),
      following: json['following'].toString(),
    );
  }
}

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController usernameController = TextEditingController();
  List<GithubUser> githubUser = [];
  bool searched = false;

  Future<void> getUserData(String username) async {
    try {
      Response response = await Dio().get(githubUserUrl + username);

      GithubUser user = GithubUser.fromJson(response.data);

      setState(() {
        searched = true;
        githubUser.clear();
        githubUser.add(user);
      });
    } catch (e) {
      setState(() {
        searched = true;
        githubUser.clear();
      });
      print('Error: $e');
    }
  }

  void clearSearch() {
    setState(() {
      searched = false;
      githubUser.clear();
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
      backgroundColor: backgroundColor,
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
          if (searched)
            Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: IconButton(
                onPressed: () {
                  clearSearch();
                }, // Use the clearSearch method to remove user details
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                  size: 50,
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
                              controller: usernameController,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                              autocorrect: false,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'username',
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18,
                                ),
                                contentPadding: EdgeInsets.all(12),
                              ),
                              onSubmitted: (value) {
                                getUserData(value);
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              getUserData(usernameController.text);
                            },
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (searched)
                    if (githubUser.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          height: height * 0.6,
                          width: width - 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: dotColor,
                              width: 2,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(githubUser[0].avatarUrl),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  githubUser[0].name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '@${githubUser[0].login}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 70,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: dotColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            githubUser[0].followers,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Followers',
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Container(
                                      height: 70,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: dotColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            githubUser[0].following,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Following',
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 70,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        githubUser[0].publicRepos,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Public Repos',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().slideY(
                            delay: Duration(milliseconds: 100),
                            begin: 1.0,
                            end: 0,
                            curve: Curves.easeOut,
                            duration: Duration(
                              milliseconds: 250,
                            ),
                          ),
                  if (githubUser.isEmpty && searched)
                    Container(
                      padding: EdgeInsets.all(20),
                      height: height * 0.6,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: dotColor,
                          width: 2,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'No user found.',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ).animate().slideY(
                          begin: 1.0,
                          end: 0,
                          curve: Curves.easeOut,
                          duration: Duration(
                            milliseconds: 250,
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

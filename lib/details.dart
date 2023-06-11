// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grid_paper/grid_paper.dart';
import 'package:dio/dio.dart';
import 'constants.dart';
import 'home.dart';

class GithubUser {
  final String login;
  final String name;
  final String publicRepos;
  final String followers;
  final String following;
  final String avatarUrl;
  final String bio;

  GithubUser({
    required this.login,
    required this.avatarUrl,
    required this.name,
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.bio,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      bio: json['bio'] ?? 'bio',
      avatarUrl: json['avatar_url'] ?? '',
      login: json['login'] ?? 'username',
      name: json['name'] ?? 'name',
      publicRepos: json['public_repos'].toString() ?? 'no. of repos',
      followers: json['followers'].toString() ?? 'followers',
      following: json['following'].toString() ?? 'following',
    );
  }
}

class UserDetails extends StatefulWidget {
  final GitHubUser user;

  UserDetails({required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  GithubUser? githubUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData(widget.user.login);
  }

  Future<void> getUserData(String username) async {
    try {
      Response response =
          await Dio().get('https://api.github.com/users/$username');

      if (response.statusCode == 200) {
        GithubUser user = GithubUser.fromJson(response.data);

        setState(() {
          githubUser = user;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        //print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      //  print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
        title: Text(
          'User Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
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
            child: isLoading
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(githubUser!.avatarUrl),
                        ),
                        SizedBox(height: 10),
                        Text(
                          githubUser!.name,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '@${githubUser!.login}',
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
                                    githubUser!.followers,
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
                                      color: Colors.white.withOpacity(0.6),
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
                                    githubUser!.following,
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
                                      color: Colors.white.withOpacity(0.6),
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
                                githubUser!.publicRepos,
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
                        SizedBox(height: 10),
                        if (githubUser!.bio != 'bio')
                          Container(
                            //height: 70,
                            height: height * 0.2,
                            width: width - 40,
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: dotColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    githubUser!.bio,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Bio',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
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

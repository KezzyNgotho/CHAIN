import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/comment_modal.dart';
import 'widgets/explore_modal.dart';
import 'widgets/search_modal.dart';
import 'widgets/following_modal.dart';
import 'widgets/live_modal.dart';
import 'widgets/prediction_card.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cassandra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false;
  bool isFollowing = false;
  bool isLive = false;
  bool isExplore = false;
  bool isSearch = false;
  bool isComment = false;
  bool isProfile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          'Cassandra',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
                isExplore = false;
                isLive = false;
                isProfile = false;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.explore,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                isExplore = !isExplore;
                isSearch = false;
                isLive = false;
                isProfile = false;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.live_tv,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                isLive = !isLive;
                isSearch = false;
                isExplore = false;
                isProfile = false;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                isProfile = !isProfile;
                isSearch = false;
                isExplore = false;
                isLive = false;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isSearch)
              const SearchModal(),
            if (isExplore)
              const ExploreModal(),
            if (isLive)
              const LiveModal(),
            if (isProfile)
              const ProfileScreen(),
            if (!isSearch && !isExplore && !isLive && !isProfile)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return PredictionCard(
                    title: 'Prediction $index',
                    timeLeft: '2h left',
                    amount: '\$100',
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
} 
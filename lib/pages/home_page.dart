import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:assessment_leeza_app/pages/assessments/adult_assessment_page.dart';
import 'package:assessment_leeza_app/pages/assessments/child_assessment_page.dart';
import 'package:assessment_leeza_app/pages/talks_page.dart';
import 'package:assessment_leeza_app/pages/schedule_page.dart';
import 'package:assessment_leeza_app/pages/profile_page.dart';
import 'package:assessment_leeza_app/pages/chatbot_page.dart';
import 'package:assessment_leeza_app/pages/upload_story_page.dart';
import 'package:assessment_leeza_app/utils/app_colors.dart';
import 'package:assessment_leeza_app/widgets/bottom_navigation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreenContent(),
    TalksPage(),
    SchedulePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFFAFAFA)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Row(
              children: [
                Text(
                  "Welcome to ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE5A0FF),
                    letterSpacing: 0.8,
                  ),
                ),
                Image.asset(
                  'assets/images/welcome.jpg',
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Who are you taking\nthe test for?",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            _buildOptionCard(
              context,
              title: "For Yourself",
              subtitle: "Take an assessment for your mental well-being",
              imagePath: 'assets/images/yourself.svg',
              color: Color(0xFFF9F3E3),
              page: AdultAssessments(),
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              title: "For Your Child",
              subtitle: "Assess your child's mental health",
              imagePath: 'assets/images/child.svg',
              color: Color(0xFFFFD699),
              page: ChildAssessments(),
            ),
            const SizedBox(height: 16),
            _buildBotOptionCard(
              context,
              title: "Chat with Leeza AI",
              subtitle: "Get instant support and guidance",
              color: Color(0xFFF5FAF4),
              page: const ChatbotPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required String title,
      required String subtitle,
      required String imagePath,
      required Color color,
      required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (title == "For Your Child")
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SvgPicture.asset(
                  imagePath,
                  width: 70,
                  height: 70,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (title == "For Yourself")
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SvgPicture.asset(
                  imagePath,
                  width: 70,
                  height: 70,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotOptionCard(BuildContext context,
      {required String title,
      required String subtitle,
      required Color color,
      required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

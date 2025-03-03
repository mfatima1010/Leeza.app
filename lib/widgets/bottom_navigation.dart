import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:assessment_leeza_app/pages/home_page.dart';
import 'package:assessment_leeza_app/pages/talks_page.dart';
import 'package:assessment_leeza_app/pages/schedule_page.dart';
import 'package:assessment_leeza_app/pages/profile_page.dart';
import 'package:assessment_leeza_app/utils/app_colors.dart';
import 'package:assessment_leeza_app/pages/upload_story_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
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
      floatingActionButton: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE5A0FF), // Lighter purple (CB6BE5 → E5A0FF)
              Color(0xFFFFD27A), // Lighter yellow (F5B400 → FFD27A)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE5A0FF)
                  .withAlpha(100), // Using lighter purple for shadow
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadStoryPage()),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, size: 35, color: AppColor.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'Home'),
            _buildNavItem(1, 'Talks'),
            const SizedBox(width: 40), // Space for FAB
            _buildNavItem(2, 'Schedule'),
            _buildNavItem(3, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            _selectedIndex == index
                ? 'assets/icons/${_getIconName(label)}_filled.svg'
                : 'assets/icons/${_getIconName(label)}.svg',
            color: _selectedIndex == index ? Color(0xFFCB6BE5) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Color(0xFFCB6BE5) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _getIconName(String label) {
    switch (label) {
      case 'Home':
        return 'ic_home';
      case 'Talks':
        return 'ic_talks';
      case 'Schedule':
        return 'ic_calendar';
      case 'Profile':
        return 'ic_profile';
      default:
        return '';
    }
  }
}

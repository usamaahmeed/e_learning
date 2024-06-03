import 'package:e_learning/Features/Profile/presentation/view/profile_screen.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_screen.dart';
import 'package:e_learning/Features/Transaction/presentation/view/transaction.dart';
import 'package:e_learning/Features/indox/presentation/view/indox_screen.dart';
import 'package:e_learning/Features/my_courses/presentation/view/my_courses.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  PageController _pageController = PageController();

  final List<Widget> listOfScreens = const [
    TimelineScreen(),
    MyCourses(),
    IndoxScreen(),
    BookMark(),
    ProfileScreen(),
  ];

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  Future<bool> _onWillPop() async {
    if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
        _pageController.jumpToPage(0);
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Color(0xFFF5F9FF),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: PageView(
                controller: _pageController,
                onPageChanged: onPageChanged,
                children: listOfScreens,
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(0xFFF5F9FF),
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: onItemTapped,
            selectedItemColor: Color(0xff167F71),
            unselectedItemColor: Colors.grey.shade500,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.my_library_books_outlined),
                label: 'My Courses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mark_unread_chat_alt_outlined),
                label: 'Indox',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border_outlined),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

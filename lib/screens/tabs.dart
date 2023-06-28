import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grada_app/providers/user_provider.dart';

import 'package:grada_app/screens/add_image_screen.dart';
import 'package:grada_app/screens/main_screen.dart';
import 'package:grada_app/screens/scan_screen.dart';
import 'package:grada_app/screens/user_screen.dart';
import 'package:grada_app/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  // final List<AppUser> users;

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
   List<File> _selectedImages = [];

  void onTabTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) {
    if (identifier == 'profile') {
      final users = ref.watch(userProvider);
      final user = users.isNotEmpty ? users[0] : null;
      if (user != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => UserScreen(
                user: user,
              ))));
      }
    } else {
      Navigator.of(context).pop();
    }
  }
   void _pickImages(List<File> images) {
    setState(() {
      _selectedImages = images;
    });
   }

  @override
  Widget build(BuildContext context) {
    var activePageTitle = 'MyGraDA';

    Widget activePage = const MainScreen();
    if (_selectedPageIndex == 1) {
      activePage = const AddImageScreen();
      activePageTitle = 'Take a picture';
    }
    if (_selectedPageIndex == 2) {
      activePage = const ScanScreen();
      activePageTitle = 'Scan a QR';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
        onPickImage: _pickImages,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home page'),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera), label: 'Take a picture'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Scan QR')
        ],
      ),
    );
  }
}

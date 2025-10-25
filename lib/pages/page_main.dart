import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:petrosafe_app/widgets/home/content_home.dart';
import 'package:petrosafe_app/widgets/settings/content_settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    Center(child: Text("Attendance Page")),
    SettingsContent(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: Padding(
          padding: EdgeInsets.only(top: 16),
          child: FloatingActionButton(
            backgroundColor: Colors.blue[900],
            shape: const CircleBorder(),
            onPressed: () => {},

            child: const Icon(
              FeatherIcons.search,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          color: Colors.white,
          elevation: 8,
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  iconSize: 28,
                  onPressed: () => _onItemTapped(0),
                  icon: Icon(
                    FeatherIcons.home,
                    color: _selectedIndex == 0 ? Colors.blue[900] : Colors.grey,
                  ),
                ),
                const SizedBox(width: 32),
                IconButton(
                  iconSize: 28,
                  onPressed: () => _onItemTapped(2),
                  icon: Icon(
                    FeatherIcons.settings,
                    color: _selectedIndex == 2 ? Colors.blue[900] : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

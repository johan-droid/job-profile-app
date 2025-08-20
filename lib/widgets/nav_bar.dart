import 'package:flutter/material.dart';
import '../app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  final List<BottomNavItem> items;
  final Color activeColor;
  final Color inactiveColor;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    this.activeColor = AppTheme.primaryColor,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = selectedIndex == index;
          
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected ? activeColor : inactiveColor,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? activeColor : inactiveColor,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.label,
  });
}

class AnimatedNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  final List<BottomNavItem> items;
  final Color bgColor;
  final Color indicatorColor;
  final Color activeColor;
  final Color inactiveColor;

  const AnimatedNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    this.bgColor = Colors.white,
    this.indicatorColor = AppTheme.primaryColor,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = selectedIndex == index;
              
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        color: isSelected ? activeColor : inactiveColor,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? activeColor : inactiveColor,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: (MediaQuery.of(context).size.width / items.length) * selectedIndex,
            child: Container(
              width: MediaQuery.of(context).size.width / items.length,
              height: 70,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SideNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  final List<BottomNavItem> items;
  final Color bgColor;
  final Color activeColor;
  final Color inactiveColor;
  final String userName;
  final String? userImageUrl;

  const SideNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    required this.userName,
    this.userImageUrl,
    this.bgColor = Colors.white,
    this.activeColor = AppTheme.primaryColor,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: bgColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: activeColor,
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: userImageUrl != null
                        ? NetworkImage(userImageUrl!)
                        : null,
                    child: userImageUrl == null
                        ? Text(
                            userName[0],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = selectedIndex == index;
                
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? activeColor : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  tileColor: isSelected ? activeColor.withOpacity(0.1) : null,
                  onTap: () => onTap(index),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}

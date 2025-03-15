// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_guide/providers/theme_provider.dart';
import 'dashboard_screen.dart';
import 'add_task_screen.dart';
import 'reports_screen.dart';
import 'dua_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Widget> _tabs = [
    const DashboardScreen(),
    const AddTaskScreen(),
    const DuaScreen(),
    const ReportsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.mosque_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'تنظيم عبادات رمضان',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                    tooltip: themeProvider.isDarkMode ? 'الوضع النهاري' : 'الوضع الليلي',
                  ),
                );
              },
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _animation,
          child: IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.navigationBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(
                    icon: Icons.list_rounded,
                    label: 'المهام',
                    isSelected: _currentIndex == 0,
                    onTap: () => _onTabChanged(0),
                  ),
                  _NavBarItem(
                    icon: Icons.add_task_rounded,
                    label: 'إضافة',
                    isSelected: _currentIndex == 1,
                    onTap: () => _onTabChanged(1),
                  ),
                  _NavBarItem(
                    icon: Icons.menu_book_rounded,
                    label: 'الأدعية',
                    isSelected: _currentIndex == 2,
                    onTap: () => _onTabChanged(2),
                  ),
                  _NavBarItem(
                    icon: Icons.insights_rounded,
                    label: 'التقارير',
                    isSelected: _currentIndex == 3,
                    onTap: () => _onTabChanged(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16 : 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                size: isSelected ? 24 : 22,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                  width: isSelected ? 8 : 0,
                ),
              ),
              if (isSelected)
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

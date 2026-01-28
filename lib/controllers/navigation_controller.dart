import 'package:flutter/material.dart';
import '../models/navigation_item.dart';

class NavigationController extends ChangeNotifier {
  int _currentIndex = 0;
  
  int get currentIndex => _currentIndex;
  
  final List<NavigationItem> _items = [
    NavigationItem(
      id: 'today',
      label: 'Hari Ini',
      icon: Icons.today_rounded,
      route: '/home',
    ),
    NavigationItem(
      id: 'schedule',
      label: 'Jadwal',
      icon: Icons.calendar_month_rounded,
      route: '/kalender',
    ),
    NavigationItem(
      id: 'add',
      label: '',
      icon: Icons.add,
      route: '',
      isCenter: true,
    ),
    NavigationItem(
      id: 'assignments',
      label: 'Tugas',
      icon: Icons.assignment_rounded,
      route: '/daftarTugas',
    ),
    NavigationItem(
      id: 'settings',
      label: 'Opsi',
      icon: Icons.settings_rounded,
      route: '/pengaturan',
    ),
  ];
  
  List<NavigationItem> get items => _items;
  
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
  
  void navigateToIndex(BuildContext context, int index) {
    if (index == 2) return; 
    
    setIndex(index);
    
    final route = _items[index].route;
    if (route.isNotEmpty) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}
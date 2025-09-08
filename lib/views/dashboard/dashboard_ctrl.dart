import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/utils/storage.dart';
import 'package:the_next_big_thing/views/auth/splash/splash_ctrl.dart';

class DashboardCtrl extends GetxController {
  final RxInt _selectedIndex = 0.obs;
  final RxInt _videoCount = 0.obs;
  final RxInt _sessionCount = 0.obs;
  final RxInt _staffCount = 0.obs;
  final RxList<dynamic> _recentVideos = <dynamic>[].obs;
  final RxList<dynamic> _upcomingSessions = <dynamic>[].obs;
  final RxList<dynamic> _quickStats = <dynamic>[].obs;

  // Getters
  int get selectedIndex => _selectedIndex.value;

  int get videoCount => _videoCount.value;

  int get sessionCount => _sessionCount.value;

  int get staffCount => _staffCount.value;

  List<dynamic> get recentVideos => _recentVideos;

  List<dynamic> get upcomingSessions => _upcomingSessions;

  List<dynamic> get quickStats => _quickStats;

  bool isGuest = false;
  bool isRegularUser = false;

  // Bottom navigation items
  List<BottomNavigationBarItem> get navigationItems => [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Videos'),
    const BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Sessions'),
    if (isRegularUser) const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Staff'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  // Quick action items
  List<Map<String, dynamic>> get quickActions => [
    if (isRegularUser) {'icon': Icons.video_library, 'title': 'My Videos', 'subtitle': 'View your videos', 'route': AppRouteNames.login, 'color': Colors.blue},
    {'icon': Icons.play_circle_outline, 'title': 'Sample Videos', 'subtitle': 'Explore content', 'route': AppRouteNames.login, 'color': Colors.green},
    if (isRegularUser) {'icon': Icons.schedule, 'title': 'Book Session', 'subtitle': 'Schedule a session', 'route': AppRouteNames.login, 'color': Colors.orange},
    {'icon': Icons.event_available, 'title': 'Upcoming Sessions', 'subtitle': 'View sessions', 'route': AppRouteNames.login, 'color': Colors.purple},
    if (isRegularUser) {'icon': Icons.group_add, 'title': 'Manage Staff', 'subtitle': 'Staff operations', 'route': AppRouteNames.login, 'color': Colors.teal},
    if (isGuest) {'icon': Icons.login, 'title': 'Login', 'subtitle': 'Access full features', 'route': AppRouteNames.login, 'color': Colors.indigo},
  ];

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    _setupQuickStats();
  }

  void _setupQuickStats() {
    _quickStats.value = [
      {'title': 'Videos', 'count': _videoCount, 'icon': Icons.play_circle, 'color': Colors.blue, 'subtitle': isGuest ? 'Sample videos' : 'Your videos'},
      {'title': 'Sessions', 'count': _sessionCount, 'icon': Icons.event, 'color': Colors.green, 'subtitle': isGuest ? 'Preview sessions' : 'Your sessions'},
      if (isRegularUser) {'title': 'Staff', 'count': _staffCount, 'icon': Icons.people, 'color': Colors.orange, 'subtitle': 'Team members'},
      {'title': 'Profile', 'count': 1.obs, 'icon': Icons.person, 'color': Colors.purple, 'subtitle': isGuest ? 'Guest user' : 'Your profile'},
    ];
  }

  // Load dashboard overview data
  Future<void> loadDashboardData() async {
    // await callApiConditionally(guestApi: () => _loadGuestDashboard(), regularApi: () => _loadRegularDashboard());
  }

  Future<void> _loadGuestDashboard() async {
    // try {
    //   final response = await ApiService.instance.get(endpoint: '/guest-dashboard');
    //
    //   if (response.isSuccess) {
    //     final data = response.data;
    //     _videoCount.value = (data['sample_videos'] as List?)?.length ?? 0;
    //     _sessionCount.value = (data['sample_sessions'] as List?)?.length ?? 0;
    //     _recentVideos.value = (data['sample_videos'] as List?)?.take(3).toList() ?? [];
    //     _upcomingSessions.value = (data['sample_sessions'] as List?)?.take(2).toList() ?? [];
    //   }
    // } catch (e) {
    //   handleError(e);
    // }
  }

  Future<void> _loadRegularDashboard() async {
    // try {
    //   final response = await ApiService.instance.get(endpoint: '/user-dashboard', headers: {'Authorization': 'Bearer ${_sessionManager.userToken}'});
    //   if (response.isSuccess) {
    //     final data = response.data;
    //     _videoCount.value = (data['videos_count'] as int?) ?? 0;
    //     _sessionCount.value = (data['sessions_count'] as int?) ?? 0;
    //     _staffCount.value = (data['staff_count'] as int?) ?? 0;
    //     _recentVideos.value = data['recent_videos'] ?? [];
    //     _upcomingSessions.value = data['upcoming_sessions'] ?? [];
    //   }
    // } catch (e) {
    //   handleError(e);
    // }
  }

  // Navigation methods
  void changeTabIndex(int index) {
    _selectedIndex.value = index;
  }

  void navigateToPage(String route) {
    Get.toNamed(route);
  }

  void onQuickActionTap(Map<String, dynamic> action) {
    // if (isGuest && action['route'] == AppRouteNames.login) {
    //   Get.offAllNamed(AppRouteNames.login);
    //   return;
    // }
    // Get.toNamed(action['route']);
  }

  Future<void> refreshDashboard() async {
    // setRefreshing(true);
    // await loadDashboardData();
    // setRefreshing(false);
  }

  void logout() {
    // Get.dialog(
    //   AlertDialog(
    //     title: const Text('Logout'),
    //     content: Text(isGuest ? 'Switch to login mode?' : 'Are you sure you want to logout?'),
    //     actions: [
    //       TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
    //       ElevatedButton(
    //         onPressed: () {
    //           Get.back();
    //           _performLogout();
    //         },
    //         child: const Text('Logout'),
    //       ),
    //     ],
    //   ),
    // );
  }

  void _performLogout() async {
    await clearStorage();
    Get.offNamedUntil(AppRouteNames.splash, (Route<dynamic> route) => false);
    Get.put(SplashCtrl(), permanent: true).onReady();
  }
}

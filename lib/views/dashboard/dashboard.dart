import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/views/dashboard/dashboard_ctrl.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardCtrl());
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex,
          children: [_buildHomeTab(controller), _buildVideosTab(), _buildSessionsTab(), if (controller.isRegularUser) _buildStaffTab(), _buildProfileTab()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: controller.navigationItems,
        ),
      ),
    );
  }

  Widget _buildHomeTab(DashboardCtrl controller) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(controller.isGuest ? 'Welcome Guest!' : 'Welcome Back!', style: const TextStyle(color: Colors.white)),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Theme.of(Get.context!).primaryColor, Theme.of(Get.context!).primaryColor.withOpacity(0.8)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Icon(controller.isGuest ? Icons.explore : Icons.dashboard, size: 60, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(controller.isGuest ? 'Explore our features' : 'Manage your content', style: const TextStyle(color: Colors.white70, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Quick Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildQuickStats(controller),
                  ],
                ),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildQuickActions(controller),
                  ],
                ),
              ),
            ),

            // Recent Content
            if (controller.recentVideos.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent Videos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          TextButton(onPressed: () => controller.changeTabIndex(1), child: const Text('View All')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildRecentVideos(controller),
                    ],
                  ),
                ),
              ),

            // Upcoming Sessions
            if (controller.upcomingSessions.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Upcoming Sessions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          TextButton(onPressed: () => controller.changeTabIndex(2), child: const Text('View All')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildUpcomingSessions(controller),
                    ],
                  ),
                ),
              ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(DashboardCtrl controller) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.quickStats.length,
        itemBuilder: (context, index) {
          final stat = controller.quickStats[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (stat['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (stat['color'] as Color).withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(stat['icon'] as IconData, color: stat['color'] as Color, size: 24),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    '${(stat['count'] as RxInt).value}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: stat['color'] as Color),
                  ),
                ),
                Text(stat['title'] as String, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(DashboardCtrl controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: controller.quickActions.length,
      itemBuilder: (context, index) {
        final action = controller.quickActions[index];
        return GestureDetector(
          onTap: () => controller.onQuickActionTap(action),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: (action['color'] as Color).withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(action['icon'] as IconData, color: action['color'] as Color, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  action['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Text(
                  action['subtitle'] as String,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentVideos(DashboardCtrl controller) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.recentVideos.length,
        itemBuilder: (context, index) {
          final video = controller.recentVideos[index];
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: Colors.grey[300],
                      ),
                      child: const Center(child: Icon(Icons.play_circle, size: 40)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video['title'] ?? 'Video Title',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(video['duration'] ?? '00:00', style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingSessions(DashboardCtrl controller) {
    return Column(
      children: controller.upcomingSessions.map<Widget>((session) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.event, color: Colors.blue),
            ),
            title: Text(session['title'] ?? 'Session'),
            subtitle: Text(session['date'] ?? 'Date & Time'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to session details
            },
          ),
        );
      }).toList(),
    );
  }

  // Placeholder tabs
  Widget _buildVideosTab() {
    return const Center(child: Text('Videos Tab - Will be replaced with VideosController'));
  }

  Widget _buildSessionsTab() {
    return const Center(child: Text('Sessions Tab - Will be replaced with SessionsController'));
  }

  Widget _buildStaffTab() {
    return const Center(child: Text('Staff Tab - Will be replaced with StaffController'));
  }

  Widget _buildProfileTab() {
    return const Center(child: Text('Profile Tab - Will be replaced with ProfileController'));
  }
}

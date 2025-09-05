import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/decoration.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/utils/storage.dart';
import 'package:the_next_big_thing/views/dashboard/dashboard_ctrl.dart';
import 'package:the_next_big_thing/views/splash/splash_ctrl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardCtrl>(
      init: DashboardCtrl(),
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () => Get.toNamed(AppRouteNames.profile),
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [decoration.colorScheme.primary, decoration.colorScheme.primary.withOpacity(0.8)]),
                  boxShadow: [BoxShadow(color: decoration.colorScheme.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Center(
                  child: Text(
                    _getInitials(ctrl.userData == null ? "User" : ctrl.userData["name"] ?? "User"),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: decoration.colorScheme.onPrimary),
                  ),
                ),
              ),
            ).paddingOnly(left: 5, right: 5),
            title: Text(
              ctrl.userData == null ? "User" : ctrl.userData["name"]?.toString().capitalizeFirst.toString() ?? "User",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: decoration.colorScheme.primary),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await clearStorage();
                  Get.offNamedUntil(AppRouteNames.splash, (Route<dynamic> route) => false);
                  Get.put(SplashCtrl(), permanent: true).onReady();
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  foregroundColor: WidgetStatePropertyAll(decoration.colorScheme.error),
                  backgroundColor: WidgetStatePropertyAll(decoration.colorScheme.errorContainer),
                ),
                icon: Icon(Icons.login_rounded, color: decoration.colorScheme.error),
              ),
              SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    if (name.isNotEmpty) {
      List<String> nameParts = name.trim().split(" ");
      if (nameParts.isNotEmpty) {
        String firstInitial = nameParts.first.capitalizeFirst?[0] ?? "";
        if (nameParts.length > 1) {
          String lastInitial = nameParts.last.capitalizeFirst?[0] ?? "";
          return "$firstInitial$lastInitial";
        } else {
          return firstInitial;
        }
      }
    }
    return 'U';
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_next_big_thing/firebase_options.dart';
import 'package:the_next_big_thing/utils/config/app_config.dart';
import 'package:the_next_big_thing/utils/routes/route_methods.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/utils/service/notification_service.dart';
import 'package:the_next_big_thing/utils/theme/light.dart';
import 'package:the_next_big_thing/views/no_internet.dart';
import 'package:the_next_big_thing/views/notifications/notifications_ctrl.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await GetStorage.init();
  GestureBinding.instance.resamplingEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en', null);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else {
    Firebase.app();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleNotificationClick(message);
  });
  terminatedNotification();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = (errorDetails) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };
  runApp(const MyApp());
}

String? lastHandledMessageId;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.messageId != null && message.messageId != lastHandledMessageId) {
    lastHandledMessageId = message.messageId;
    await notificationService.init();
    notificationService.showRemoteNotificationAndroid(message);
    _handleNotificationClick(message);
  }
}

void terminatedNotification() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null && initialMessage.messageId != lastHandledMessageId) {
    lastHandledMessageId = initialMessage.messageId;
    notificationService.showRemoteNotificationAndroid(initialMessage);
    _handleNotificationClick(initialMessage);
  }
}

void _handleNotificationClick(RemoteMessage message) async {
  if (Get.isRegistered<NotificationsCtrl>()) {
    final notificationsCtrl = Get.find<NotificationsCtrl>();
    notificationsCtrl.getNotifications();
  } else {
    Get.toNamed(AppRouteNames.notifications);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (BuildContext context, widget) {
        return OfflineBuilder(
          connectivityBuilder: (BuildContext context, List<ConnectivityResult> connectivity, Widget child) {
            if (connectivity.contains(ConnectivityResult.none)) {
              return const NoInternet();
            } else {
              return child;
            }
          },
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.getThemeByIndex(context),
      themeMode: ThemeMode.system,
      getPages: AppRouteMethods.pages,
      initialRoute: AppRouteNames.splash,
    );
  }
}

/// Tasks Competed///
/* Splash */
/* Introduction */
/* Login */
/* Guest */
/* Verification */
/* Register */

/// Tasks Pending///
/* Dashboard */
/* Profile */
/* Get Videos # Condition Guest user show getSampleVideos and regular user show getSampleVideos & getVideos */
/* Get Session # Condition Guest user show sampleUpcomingSession and regular user show sampleUpcomingSession & upcomingSession & requestForSessionUrl */
/* Get Staff # Condition regular user create staff, get staff's, update staff, delete staff, get staff */

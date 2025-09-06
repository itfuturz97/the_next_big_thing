import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/utils/storage.dart';
import 'package:the_next_big_thing/utils/config/session.dart';

class IntroCtrl extends GetxController with GetTickerProviderStateMixin {
  final RxInt currentPage = 0.obs;
  late PageController pageController;
  late AnimationController animationController;
  late AnimationController glowAnimationController;
  late AnimationController buttonAnimationController;

  final List<IntroItem> introItems = [
    IntroItem(
      title: 'Welcome to The Next Big Thing',
      description: 'Discover opportunities, connect with innovators, and build your future with us.',
      image: Icons.rocket_launch_rounded,
      color: const Color(0xFF6C63FF),
    ),
    IntroItem(
      title: 'Connect & Collaborate',
      description: 'Join a community of forward-thinkers and industry leaders who share your vision.',
      image: Icons.people_outline_rounded,
      color: const Color(0xFF26D0CE),
    ),
    IntroItem(
      title: 'Grow Your Business',
      description: 'Access tools, resources, and networks that help scale your ideas into reality.',
      image: Icons.trending_up_rounded,
      color: const Color(0xFFFF6B6B),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    glowAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    buttonAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    write(AppSession.isFirstTime, false);
    animationController.forward();
    glowAnimationController.repeat(reverse: true);
  }

  @override
  void onClose() {
    pageController.dispose();
    animationController.dispose();
    glowAnimationController.dispose();
    buttonAnimationController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
    animationController.reset();
    animationController.forward();
    buttonAnimationController.reset();
    buttonAnimationController.forward();
  }

  void nextPage() {
    buttonAnimationController.reset();
    buttonAnimationController.forward();
    if (currentPage.value < introItems.length - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Get.offAllNamed(AppRouteNames.login);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      buttonAnimationController.reset();
      buttonAnimationController.forward();
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void skipIntro() {
    Get.offAllNamed(AppRouteNames.login);
  }
}

class IntroItem {
  final String title;
  final String description;
  final IconData image;
  final Color color;

  IntroItem({required this.title, required this.description, required this.image, required this.color});
}

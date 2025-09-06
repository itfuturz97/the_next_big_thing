import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/decoration.dart';
import 'intro_ctrl.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroCtrl>(
      init: IntroCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: ctrl.skipIntro,
                        child: Text(
                          'Skip',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: decoration.colorScheme.onSurface.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.8),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: PageView.builder(
                      controller: ctrl.pageController,
                      onPageChanged: ctrl.onPageChanged,
                      itemCount: ctrl.introItems.length,
                      itemBuilder: (context, index) {
                        return _buildIntroPage(context, ctrl, index);
                      },
                    ),
                  ),
                  _buildPageIndicator(ctrl),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (ctrl.currentPage.value > 0)
                          TextButton.icon(
                            onPressed: ctrl.previousPage,
                            icon: Icon(Icons.arrow_back_ios, color: decoration.colorScheme.onSurface.withOpacity(0.7), size: 18),
                            label: Text(
                              'Back',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(color: decoration.colorScheme.onSurface.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )
                        else
                          const SizedBox(width: 80),
                        AnimatedBuilder(
                          animation: ctrl.buttonAnimationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (ctrl.buttonAnimationController.value * 0.05),
                              child: ElevatedButton.icon(
                                onPressed: ctrl.nextPage,
                                icon: Icon(ctrl.currentPage.value == ctrl.introItems.length - 1 ? Icons.check_rounded : Icons.arrow_forward_ios, color: Colors.white, size: 20),
                                label: Text(
                                  ctrl.currentPage.value == ctrl.introItems.length - 1 ? 'Get Started' : 'Next',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ctrl.introItems[ctrl.currentPage.value].color,
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  shadowColor: ctrl.introItems[ctrl.currentPage.value].color.withOpacity(0.3),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntroPage(BuildContext context, IntroCtrl ctrl, int index) {
    final item = ctrl.introItems[index];
    return AnimatedBuilder(
      animation: Listenable.merge([ctrl.animationController, ctrl.glowAnimationController]),
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.8 + (ctrl.animationController.value * 0.2),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [item.color.withOpacity(0.9), item.color]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: item.color.withOpacity(0.3 * ctrl.glowAnimationController.value), blurRadius: 30, spreadRadius: 5, offset: const Offset(0, 5)),
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Icon(item.image, size: 70, color: Colors.white),
                ),
              ),
              const SizedBox(height: 50),
              Transform.translate(
                offset: Offset(0, 20 * (1 - ctrl.animationController.value)),
                child: Opacity(
                  opacity: ctrl.animationController.value,
                  child: Text(
                    item.title,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(fontSize: 28, fontWeight: FontWeight.w800, color: decoration.colorScheme.onSurface, letterSpacing: 0.5, height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Transform.translate(
                offset: Offset(0, 30 * (1 - ctrl.animationController.value)),
                child: Opacity(
                  opacity: ctrl.animationController.value,
                  child: Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: decoration.colorScheme.onSurface.withOpacity(0.7),
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator(IntroCtrl ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          ctrl.introItems.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            height: 8,
            width: ctrl.currentPage.value == index ? 32 : 8,
            decoration: BoxDecoration(
              color: ctrl.currentPage.value == index ? ctrl.introItems[ctrl.currentPage.value].color : decoration.colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              boxShadow: ctrl.currentPage.value == index
                  ? [BoxShadow(color: ctrl.introItems[ctrl.currentPage.value].color.withOpacity(0.3), blurRadius: 8, spreadRadius: 1, offset: const Offset(0, 2))]
                  : [],
            ),
          ),
        ),
      ),
    );
  }
}

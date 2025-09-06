import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/config/app_assets.dart';
import 'dart:async';
import 'package:the_next_big_thing/utils/decoration.dart';
import 'package:the_next_big_thing/views/auth/splash/splash_ctrl.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _logoCtrl, _textCtrl, _backgroundCtrl, _glowCtrl;
  late Animation<double> _logoScale, _logoOpacity, _textOpacity, _backgroundOpacity, _glowAnimation;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _logoCtrl = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _textCtrl = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _backgroundCtrl = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _glowCtrl = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: const Offset(0, 0)).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _backgroundOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _backgroundCtrl, curve: Curves.easeIn));
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  void _startAnimations() {
    _backgroundCtrl.forward();
    Timer(const Duration(milliseconds: 200), () {
      _logoCtrl.forward();
      _glowCtrl.repeat(reverse: true);
    });
    Timer(const Duration(milliseconds: 600), () {
      _textCtrl.forward();
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _backgroundCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashCtrl>(
      init: SplashCtrl(),
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    decoration.colorScheme.primary,
                    decoration.colorScheme.primary.withOpacity(0.9),
                    decoration.colorScheme.tertiary.withOpacity(0.8),
                    decoration.colorScheme.secondary.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: Listenable.merge([_logoCtrl, _glowCtrl]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _logoScale.value,
                              child: Opacity(
                                opacity: _logoOpacity.value,
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: decoration.colorScheme.surface,
                                    borderRadius: decoration.allBorderRadius(70),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 25, spreadRadius: 5, offset: const Offset(0, 8)),
                                      BoxShadow(color: decoration.colorScheme.secondary.withOpacity(0.4 * _glowAnimation.value), blurRadius: 40, spreadRadius: 10),
                                    ],
                                    border: Border.all(color: decoration.colorScheme.secondary.withOpacity(0.3), width: 2),
                                    image: DecorationImage(image: const AssetImage(AppAssets.logo), fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: AnimatedBuilder(
                        animation: _textCtrl,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _textSlide,
                            child: Opacity(
                              opacity: _textOpacity.value,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [decoration.colorScheme.secondary, decoration.colorScheme.onPrimary, decoration.colorScheme.secondary],
                                      stops: const [0.0, 0.5, 1.0],
                                    ).createShader(bounds),
                                    child: Text(
                                      'THE NEXT BIG THING',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 3,
                                        shadows: [const Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: decoration.colorScheme.secondary.withOpacity(0.15),
                                      borderRadius: decoration.allBorderRadius(20),
                                      border: Border.all(color: decoration.colorScheme.secondary.withOpacity(0.3), width: 1),
                                    ),
                                    child: Text(
                                      'Your Journey Starts Here',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 16,
                                        color: decoration.colorScheme.surface.withOpacity(0.95),
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: AnimatedBuilder(
                        animation: _backgroundCtrl,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _backgroundOpacity.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(decoration.colorScheme.secondary.withOpacity(0.9)),
                                    backgroundColor: decoration.colorScheme.surface.withOpacity(0.2),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading...',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: decoration.colorScheme.surface.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

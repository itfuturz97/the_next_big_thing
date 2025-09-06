import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:the_next_big_thing/views/auth/verification/verification_ctrl.dart';
import 'dart:async';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> with TickerProviderStateMixin {
  late AnimationController _fadeController, _slideController, _pulseController;
  late Animation<double> _fadeAnimation, _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  Timer? _timer;
  int _countdown = 120;
  bool _canResend = false, _autoVerifyTriggered = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _startCountdown();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _pulseController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: const Offset(0, 0)).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    _pulseController.repeat(reverse: true);
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_countdown > 0) {
          setState(() {
            _countdown--;
          });
        } else {
          setState(() {
            _canResend = true;
          });
          timer.cancel();
        }
      }
    });
  }

  void _resetCountdown() {
    setState(() {
      _countdown = 120;
      _canResend = false;
    });
    _startCountdown();
  }

  String _formatCountdown() {
    int minutes = _countdown ~/ 60;
    int seconds = _countdown % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationCtrl>(
      init: VerificationCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
                          ),
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                        ),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, spreadRadius: 2)],
                                      ),
                                      child: Icon(Icons.sms_outlined, size: 32, color: Theme.of(context).primaryColor),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Verify Your Number",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "Code sent to ",
                                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w300),
                                    children: [
                                      TextSpan(
                                        text: "+91 ${_formatPhoneNumber(ctrl.mobileNumber)}",
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                                  label: const Text(
                                    "Change Number",
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  "Enter Verification Code",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                PinCodeTextField(
                                  appContext: context,
                                  length: 4,
                                  onChanged: (value) {
                                    ctrl.otp.value = value;
                                    if (value.length == 4 && !_autoVerifyTriggered) {
                                      _autoVerifyTriggered = true;
                                      Future.delayed(const Duration(milliseconds: 300), () {
                                        if (mounted) {
                                          HapticFeedback.lightImpact();
                                          ctrl.verifyOtp();
                                          _autoVerifyTriggered = false;
                                        }
                                      });
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                  animationType: AnimationType.scale,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(12),
                                    fieldHeight: 56,
                                    fieldWidth: 48,
                                    activeFillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                    inactiveFillColor: Colors.grey[50],
                                    selectedFillColor: Theme.of(context).primaryColor.withOpacity(0.15),
                                    activeColor: Theme.of(context).primaryColor,
                                    inactiveColor: Colors.grey[300],
                                    selectedColor: Theme.of(context).primaryColor,
                                    borderWidth: 2,
                                  ),
                                  cursorColor: Theme.of(context).primaryColor,
                                  enableActiveFill: true,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  hapticFeedbackTypes: HapticFeedbackTypes.selection,
                                ),
                                const SizedBox(height: 32),
                                Obx(
                                  () => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: ctrl.isLoading.value ? null : () => ctrl.verifyOtp(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        foregroundColor: Colors.white,
                                        elevation: ctrl.isLoading.value ? 0 : 8,
                                        shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        disabledBackgroundColor: Colors.grey[300],
                                      ),
                                      child: ctrl.isLoading.value
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                                ),
                                                const SizedBox(width: 12),
                                                const Text("Verifying...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                              ],
                                            )
                                          : const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.verified_outlined),
                                                SizedBox(width: 8),
                                                Text("Verify Code", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_canResend ? "Didn't receive code?" : "Resend code in ${_formatCountdown()}", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                    TextButton.icon(
                                      onPressed: _canResend && !ctrl.isLoading.value
                                          ? () {
                                              ctrl.resendOtp();
                                              _resetCountdown();
                                              HapticFeedback.lightImpact();
                                            }
                                          : null,
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                        backgroundColor: _canResend && !ctrl.isLoading.value ? Theme.of(context).primaryColor.withOpacity(0.05) : Colors.transparent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      icon: Icon(Icons.refresh_rounded, color: _canResend && !ctrl.isLoading.value ? Theme.of(context).primaryColor : Colors.grey[400], size: 18),
                                      label: Text(
                                        "Request again",
                                        style: TextStyle(
                                          color: _canResend && !ctrl.isLoading.value ? Theme.of(context).primaryColor : Colors.grey[400],
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ).marginOnly(top: 10),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.blue[200]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.security_outlined, color: Colors.blue[600], size: 18),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          "Your information is encrypted and secure",
                                          style: TextStyle(fontSize: 12, color: Colors.blue[600], fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
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

  String _formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length >= 10) {
      return "${phoneNumber.substring(0, 5)} ${phoneNumber.substring(5)}";
    }
    return phoneNumber;
  }
}

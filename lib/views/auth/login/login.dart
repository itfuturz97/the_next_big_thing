import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/config/app_assets.dart';
import 'package:the_next_big_thing/views/auth/login/login_ctrl.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late AnimationController _fadeController, _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: const Offset(0, 0)).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginCtrl>(
      init: LoginCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Form(
              key: ctrl.formKey,
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
                                Hero(
                                  tag: 'logo',
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, spreadRadius: 2)],
                                      image: DecorationImage(image: const AssetImage(AppAssets.logo), fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Welcome Back!",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Sign in to continue your journey",
                                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
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

                                  // Phone Number Input
                                  _buildEnhancedTextField(
                                    controller: ctrl.mobileController,
                                    label: "Mobile Number",
                                    hint: "Enter your mobile number",
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    autofillHints: const [AutofillHints.telephoneNumber],
                                    inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\+91')), FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                    validator: (value) => value!.length != 10 ? "Please enter a valid 10-digit number" : null,
                                  ),
                                  const SizedBox(height: 32),
                                  Obx(
                                    () => AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: ctrl.isLoading.value ? null : () => ctrl.login(),
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
                                                  const Text("Signing In...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                                ],
                                              )
                                            : const Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.login_rounded),
                                                  SizedBox(width: 8),
                                                  Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(child: Divider(color: Colors.grey[300])),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          "OR",
                                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(child: Divider(color: Colors.grey[300])),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Obx(
                                    () => SizedBox(
                                      height: 56,
                                      child: OutlinedButton(
                                        onPressed: ctrl.isGuestLoading.value ? null : () => ctrl.guestLogin(),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child: ctrl.isGuestLoading.value
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    "Loading...",
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.person_outline_rounded, color: Theme.of(context).primaryColor),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "Continue as Guest",
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: TextButton(
                                      onPressed: () => Get.toNamed('/register'),
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Don't have an account? ",
                                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                          children: [
                                            TextSpan(
                                              text: "Sign Up",
                                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      "By signing in, you agree to our\nTerms of Service and Privacy Policy",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.4),
                                    ),
                                  ),
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
          ),
        );
      },
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 16),
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            counterText: "",
            hintText: hint,
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ),
      ],
    );
  }
}

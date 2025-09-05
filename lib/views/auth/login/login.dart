import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/decoration.dart';
import 'package:the_next_big_thing/views/auth/login/login_ctrl.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginCtrl>(
      init: LoginCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: Form(
              key: ctrl.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Welcome Back!",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                          ),
                          const SizedBox(height: 8),
                          Text("Sign in with your mobile number", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: ctrl.mobileController,
                      label: "Mobile Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\+91')), FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                      validator: (value) => value!.length != 10 ? "Please enter a valid 10-digit number" : null,
                    ),
                    const SizedBox(height: 32),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: ctrl.isLoading.value ? null : () => ctrl.login(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                          child: ctrl.isLoading.value
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                              : const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: ctrl.isGuestLoading.value ? null : () => ctrl.guestLogin(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[400]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: ctrl.isGuestLoading.value
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)))
                              : Text(
                                  "Continue as Guest",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        "By signing in, you agree to our\nTerms of Service and Privacy Policy",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 16),
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterText: "",
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: decoration.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

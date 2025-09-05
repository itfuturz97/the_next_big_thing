import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:the_next_big_thing/views/auth/verification/verification_ctrl.dart';

class Verification extends StatelessWidget {
  const Verification({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationCtrl>(
      init: VerificationCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Verify Your Number",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Enter the 6-digit OTP sent to\n${ctrl.mobileNumber}",
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      onChanged: (value) => ctrl.otp.value = value,
                      keyboardType: TextInputType.number,
                      textStyle: const TextStyle(fontSize: 20),
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 45,
                        activeFillColor: Colors.grey[50],
                        inactiveFillColor: Colors.grey[50],
                        selectedFillColor: Colors.grey[50],
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.grey[300],
                        selectedColor: Theme.of(context).primaryColor,
                        errorBorderColor: Colors.red,
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      enableActiveFill: true,
                      boxShadows: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: ctrl.isLoading.value ? null : () => ctrl.verifyOtp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child: ctrl.isLoading.value
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                            : const Text("Verify OTP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: ctrl.isLoading.value ? null : () => ctrl.resendOtp(),
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(fontSize: 14, color: ctrl.isLoading.value ? Colors.grey : Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      "By verifying, you agree to our\nTerms of Service and Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

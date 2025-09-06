import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_next_big_thing/utils/helper.dart';
import 'package:the_next_big_thing/views/auth/register/register_ctrl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  late AnimationController _slideController, _fadeController;
  int currentStep = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    _fadeController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
      _pageController.animateToPage(currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      HapticFeedback.lightImpact();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.animateToPage(currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterCtrl>(
      init: RegisterCtrl(),
      builder: (ctrl) {
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: Form(
                        key: ctrl.formKey,
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [_buildPersonalInfoStep(ctrl), _buildContactInfoStep(ctrl), _buildBusinessInfoStep(ctrl)],
                        ),
                      ),
                    ),
                    if (!isKeyboardVisible) _buildBottomNavigation(ctrl),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)]),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(_getStepTitle(), style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9))),
                  ],
                ),
              ),
              Text(
                "${currentStep + 1} of 3",
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            height: 4,
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            decoration: BoxDecoration(
              color: index <= currentStep ? Colors.white : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
              boxShadow: index <= currentStep ? [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 1))] : null,
            ),
          ),
        );
      }),
    );
  }

  String _getStepTitle() {
    switch (currentStep) {
      case 0:
        return "Let's start with your basic information";
      case 1:
        return "How can we reach you?";
      case 2:
        return "Tell us about your business (Optional)";
      default:
        return "";
    }
  }

  Widget _buildPersonalInfoStep(RegisterCtrl ctrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () => _showImagePickerDialog(ctrl),
              child: Stack(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Theme.of(context).primaryColor.withOpacity(0.1), Theme.of(context).primaryColor.withOpacity(0.05)],
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 3),
                      boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), blurRadius: 20, spreadRadius: 2)],
                    ),
                    child: ctrl.profilePicPath != null
                        ? ClipOval(child: Image.file(ctrl.profilePicPath!, fit: BoxFit.cover))
                        : Icon(Icons.person_outline_rounded, size: 50, color: Theme.of(context).primaryColor),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildEnhancedTextField(
            controller: ctrl.nameController,
            label: "Full Name",
            hint: "Enter your full name",
            icon: Icons.person_outline_rounded,
            validator: (value) => value!.isEmpty ? "Name is required" : null,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => _selectDate(context, ctrl),
            child: AbsorbPointer(
              child: _buildEnhancedTextField(
                controller: ctrl.dobController,
                label: "Date of Birth",
                hint: "Select your date of birth",
                icon: Icons.calendar_today_outlined,
                validator: (value) => value!.isEmpty ? "Date of birth is required" : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoStep(RegisterCtrl ctrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildEnhancedTextField(
            controller: ctrl.emailController,
            label: "Email Address",
            hint: "Enter your email address",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => !GetUtils.isEmail(value!) ? "Enter a valid email" : null,
          ),
          const SizedBox(height: 24),
          _buildEnhancedTextField(
            controller: ctrl.mobileController,
            label: "Mobile Number",
            hint: "Enter your mobile number",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\+91')), FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
            validator: (value) => value!.length != 10 ? "Enter a valid 10-digit number" : null,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildEnhancedTextField(
                  controller: ctrl.cityController,
                  label: "City",
                  hint: "Enter city",
                  icon: Icons.location_city_outlined,
                  validator: (value) => value!.isEmpty ? "City is required" : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEnhancedTextField(
                  controller: ctrl.stateController,
                  label: "State",
                  hint: "Enter state",
                  icon: Icons.map_outlined,
                  validator: (value) => value!.isEmpty ? "State is required" : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildEnhancedTextField(
            controller: ctrl.countryController,
            label: "Country",
            hint: "Enter country",
            icon: Icons.public_outlined,
            validator: (value) => value!.isEmpty ? "Country is required" : null,
          ),
          const SizedBox(height: 24),
          _buildEnhancedTextField(controller: ctrl.addressController, label: "Address (Optional)", hint: "Enter your address", icon: Icons.home_outlined, maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoStep(RegisterCtrl ctrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text("This section is optional but helps us provide better services", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildEnhancedTextField(controller: ctrl.businessNameController, label: "Business Name", hint: "Enter your business name", icon: Icons.business_outlined),
          const SizedBox(height: 24),
          _buildEnhancedTextField(
            controller: ctrl.businessCategoryController,
            label: "Business Category",
            hint: "e.g., Technology, Retail, Services",
            icon: Icons.category_outlined,
          ),
          const SizedBox(height: 32),
          Text(
            "Social Media Links (Optional)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
          ),
          const SizedBox(height: 16),
          _buildEnhancedTextField(
            controller: ctrl.facebookController,
            label: "Facebook",
            hint: "Facebook profile URL",
            icon: Icons.facebook_outlined,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),
          _buildEnhancedTextField(
            controller: ctrl.instagramController,
            label: "Instagram",
            hint: "Instagram profile URL",
            icon: Icons.camera_alt_outlined,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),
          _buildEnhancedTextField(controller: ctrl.linkedinController, label: "LinkedIn", hint: "LinkedIn profile URL", icon: Icons.work_outline, keyboardType: TextInputType.url),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(RegisterCtrl ctrl) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousStep,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text("Back"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: currentStep == 0 ? 1 : 2,
            child: Obx(
              () => ElevatedButton.icon(
                onPressed: ctrl.isLoading.value
                    ? null
                    : () {
                        if (currentStep < 2) {
                          _nextStep();
                        } else {
                          ctrl.register();
                        }
                      },
                icon: ctrl.isLoading.value
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                    : Icon(currentStep < 2 ? Icons.arrow_forward_rounded : Icons.check_rounded),
                label: Text(ctrl.isLoading.value ? "Creating..." : (currentStep < 2 ? "Next" : "Create Account")),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
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
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 16),
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

  void _showImagePickerDialog(RegisterCtrl ctrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 20),
                  const Text("Select Profile Picture", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImageSourceOption(
                        icon: Icons.camera_alt_rounded,
                        label: "Camera",
                        onTap: () async {
                          Navigator.pop(context);
                          ctrl.profilePicPath = await helper.pickImage(source: ImageSource.camera);
                          ctrl.update();
                        },
                      ),
                      _buildImageSourceOption(
                        icon: Icons.photo_library_rounded,
                        label: "Gallery",
                        onTap: () async {
                          Navigator.pop(context);
                          ctrl.profilePicPath = await helper.pickImage(source: ImageSource.gallery);
                          ctrl.update();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, RegisterCtrl ctrl) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor)),
          child: child!,
        );
      },
    );
    if (picked != null) {
      ctrl.dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }
}

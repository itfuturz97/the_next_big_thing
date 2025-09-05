import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_next_big_thing/utils/helper.dart';
import 'package:the_next_big_thing/views/auth/register/register_ctrl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterCtrl>(
      init: RegisterCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: Form(
              key: ctrl.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Welcome!",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                          ),
                          const SizedBox(height: 8),
                          Text("Create your account to get started", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: GestureDetector(
                        onTap: () => _showImagePickerDialog(ctrl),
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey[300]!, width: 2),
                          ),
                          child: ctrl.profilePicPath != null
                              ? ClipOval(child: Image.file(ctrl.profilePicPath!, fit: BoxFit.cover))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt_outlined, size: 32, color: Colors.grey[600]),
                                    const SizedBox(height: 8),
                                    Text("Add Photo", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle("Personal Information"),
                    const SizedBox(height: 16),
                    _buildTextField(controller: ctrl.nameController, label: "Full Name", icon: Icons.person_outline, validator: (value) => value!.isEmpty ? "Please enter your name" : null),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: ctrl.emailController,
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => !GetUtils.isEmail(value!) ? "Please enter a valid email" : null,
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectDate(context, ctrl),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: ctrl.dobController,
                          label: "Date of Birth",
                          icon: Icons.calendar_today_outlined,
                          validator: (value) => value!.isEmpty ? "Please select your date of birth" : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle("Address Information"),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(controller: ctrl.cityController, label: "City", icon: Icons.location_city_outlined, validator: (value) => value!.isEmpty ? "Please enter city" : null),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(controller: ctrl.stateController, label: "State", icon: Icons.map_outlined, validator: (value) => value!.isEmpty ? "Please enter state" : null),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(controller: ctrl.countryController, label: "Country", icon: Icons.public_outlined, validator: (value) => value!.isEmpty ? "Please enter country" : null),
                    const SizedBox(height: 16),
                    _buildTextField(controller: ctrl.addressController, label: "Address (Optional)", icon: Icons.home_outlined, maxLines: 3),
                    const SizedBox(height: 24),
                    _buildSectionTitle("Business Information (Optional)"),
                    const SizedBox(height: 16),
                    _buildTextField(controller: ctrl.businessNameController, label: "Business Name", icon: Icons.business_outlined),
                    const SizedBox(height: 16),
                    _buildTextField(controller: ctrl.businessCategoryController, label: "Business Category", icon: Icons.category_outlined),
                    const SizedBox(height: 24),
                    _buildSectionTitle("Social Media (Optional)"),
                    const SizedBox(height: 16),
                    _buildTextField(controller: ctrl.facebookController, label: "Facebook Profile", icon: Icons.facebook_outlined, keyboardType: TextInputType.url),
                    const SizedBox(height: 16),
                    _buildTextField(controller: ctrl.instagramController, label: "Instagram Profile", icon: Icons.camera_alt_outlined, keyboardType: TextInputType.url),
                    const SizedBox(height: 16),
                    _buildTextField(controller: ctrl.twitterController, label: "Twitter Profile", icon: Icons.alternate_email, keyboardType: TextInputType.url),
                    const SizedBox(height: 16),
                    _buildTextField(controller: ctrl.linkedinController, label: "LinkedIn Profile", icon: Icons.work_outline, keyboardType: TextInputType.url),
                    const SizedBox(height: 32),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: ctrl.isLoading.value ? null : () => ctrl.register(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                          child: ctrl.isLoading.value
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                              : const Text("Create Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        "By creating an account, you agree to our\nTerms of Service and Privacy Policy",
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
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
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
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

  void _showImagePickerDialog(RegisterCtrl ctrl) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: ClipRRect(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                  const Text("Select Profile Picture", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImageSourceOption(
                        icon: Icons.camera_alt,
                        label: "Camera",
                        onTap: () async {
                          Navigator.pop(context);
                          ctrl.profilePicPath = await helper.pickImage(source: ImageSource.camera);
                          ctrl.update();
                        },
                      ),
                      _buildImageSourceOption(
                        icon: Icons.photo_library,
                        label: "Gallery",
                        onTap: () async {
                          Navigator.pop(context);
                          ctrl.profilePicPath = await helper.pickImage(source: ImageSource.gallery);
                          ctrl.update();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 30, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
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

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/agrifair_logo.dart';
import '../widgets/primary_button.dart';
import 'otp_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _gender;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _nameController,
      _usernameController,
      _emailController,
      _passwordController,
      _confirmController,
    ]) {
      c.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() => setState(() {});

  bool get _passwordsMatch =>
      _passwordController.text == _confirmController.text;

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty &&
      _gender != null &&
      _usernameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmController.text.isNotEmpty &&
      _passwordsMatch;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          email: _emailController.text.trim(),
          fullName: _nameController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryDark,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Center(child: AgriFairLogo()),
              const SizedBox(height: 36),
              _buildHeroText(),
              const SizedBox(height: 32),
              _buildForm(),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Create Account',
                trailingIcon: Icons.arrow_forward,
                onPressed: _canSubmit ? _handleSignUp : null,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              _buildSignInPrompt(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create\nAccount',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    final showMismatch = _confirmController.text.isNotEmpty && !_passwordsMatch;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Full Name'),
          _buildField(
            controller: _nameController,
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            action: TextInputAction.next,
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Please enter your name';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildLabel('Gender'),
          _buildGenderField(),
          const SizedBox(height: 14),
          _buildLabel('Username'),
          _buildField(
            controller: _usernameController,
            hint: 'Choose a username',
            icon: Icons.alternate_email_outlined,
            action: TextInputAction.next,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please create a username';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildLabel('Email'),
          _buildField(
            controller: _emailController,
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            action: TextInputAction.next,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildLabel('Password'),
          _buildPasswordField(
            controller: _passwordController,
            hint: 'Create a password',
            obscure: _obscurePassword,
            onToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            action: TextInputAction.next,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter a password';
              if (v.length < 6) return 'At least 6 characters required';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildLabel('Confirm Password'),
          _buildPasswordField(
            controller: _confirmController,
            hint: 'Re-enter your password',
            obscure: _obscureConfirm,
            onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
            action: TextInputAction.done,
            onSubmitted: (_) => _canSubmit ? _handleSignUp() : null,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password';
              if (v != _passwordController.text)
                return 'Passwords do not match';
              return null;
            },
          ),
          if (showMismatch)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 8),
              child: Text(
                'Passwords do not match',
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      initialValue: _gender,
      isExpanded: true,
      hint: const Text(
        'Select',
        style: TextStyle(color: AppColors.textMuted, fontSize: 15),
      ),
      style: const TextStyle(color: AppColors.textDark, fontSize: 15),
      icon: const Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(Icons.arrow_drop_down, color: AppColors.textMuted),
      ),
      decoration: const InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Icon(Icons.wc_outlined, color: AppColors.textMuted, size: 20),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
      ),
      items: const [
        DropdownMenuItem(value: 'Male', child: Text('Male')),
        DropdownMenuItem(value: 'Female', child: Text('Female')),
      ],
      onChanged: (v) => setState(() => _gender = v),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? action,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: action,
      style: const TextStyle(color: AppColors.textDark, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Icon(icon, color: AppColors.textMuted, size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    TextInputAction? action,
    void Function(String)? onSubmitted,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      textInputAction: action,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(color: AppColors.textDark, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textMuted,
              size: 20,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildSignInPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Text(
            'Log In',
            style: TextStyle(
              color: AppColors.primaryMedium,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

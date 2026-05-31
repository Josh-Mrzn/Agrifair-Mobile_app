import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/agrifair_logo.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
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
          child: _emailSent ? _buildSuccessState() : _buildFormState(),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Column(
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
          label: 'Send Reset Link',
          trailingIcon: Icons.send_outlined,
          onPressed: _handleSendLink,
          isLoading: _isLoading,
        ),
        const SizedBox(height: 24),
        _buildBackToLogin(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const Center(child: AgriFairLogo()),
        const SizedBox(height: 48),
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 44,
              color: AppColors.primaryMedium,
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Check Your Email',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'We\'ve sent a password reset link to\n${_emailController.text.trim()}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Didn\'t receive it? Check your spam folder.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 40),
        PrimaryButton(
          label: 'Back to Log In',
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() => _emailSent = false);
            },
            child: const Text(
              'Try a different email',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Text(
            'ADMIN MANAGEMENT SYSTEM',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
              letterSpacing: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Forgot\nPassword?',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Enter your email and we\'ll send you a link to reset your password.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _handleSendLink(),
        style: const TextStyle(color: AppColors.textDark, fontSize: 15),
        decoration: const InputDecoration(
          hintText: 'Email address',
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              Icons.email_outlined,
              color: AppColors.textMuted,
              size: 20,
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return 'Please enter your email';
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
            return 'Enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBackToLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.arrow_back, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Text(
            'Back to Log In',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

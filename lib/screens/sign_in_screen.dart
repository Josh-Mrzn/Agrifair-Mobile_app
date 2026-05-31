import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import '../models/user_model.dart';
import 'sign_up_screen.dart';
import 'main_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    UserModel.of(context).initialize(email: _emailController.text.trim());
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Center(
                child: Image.asset(
                  'assets/products/AI, 3rd Draft(1).png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 28),
              _buildHeading(),
              const SizedBox(height: 32),
              _buildForm(),
              const SizedBox(height: 14),
              _buildForgotPassword(),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Log In',
                trailingIcon: Icons.arrow_forward,
                onPressed: _handleSignIn,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
              _buildSignUpPrompt(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return const Center(
      child: Text(
        'Welcome back to Agrifair',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
            );
          },
          child: const Text(
            'Create Account',
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

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSignIn(),
            style: const TextStyle(color: AppColors.textDark, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Icon(
                  Icons.lock_outline,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your password';
              if (v.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
          );
        },
        child: const Text(
          'Forgot password?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.primaryMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

}

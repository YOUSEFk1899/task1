import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/auth_remote_data_source.dart';
import '../data/auth_repository_impl.dart';
import 'login_page.dart';
import 'verification_page.dart' as verification;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  bool isDarkMode = false;

  late final AuthRepositoryImpl authRepository;

  @override
  void initState() {
    super.initState();

    final dio = Dio();
    final remoteDataSource = AuthRemoteDataSource(dio);

    authRepository = AuthRepositoryImpl(remoteDataSource);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (firstName.isEmpty) {
      showMessage('Please enter your first name');
      return;
    }

    if (lastName.isEmpty) {
      showMessage('Please enter your last name');
      return;
    }

    if (email.isEmpty) {
      showMessage('Please enter your email');
      return;
    }

    if (!email.contains('@')) {
      showMessage('Please enter a valid email');
      return;
    }

    if (password.isEmpty) {
      showMessage('Please enter your password');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must be at least 6 characters');
      return;
    }

    if (confirmPassword != password) {
      showMessage('Passwords do not match');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => verification.VerificationPage(email: email),
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;

      String message = 'Registration failed';

      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;

        if (data['message'] != null) {
          message = data['message'].toString();
        } else if (data['title'] != null) {
          message = data['title'].toString();
        }
      }

      showMessage(message);
    } catch (e) {
      if (!mounted) return;

      showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? const Color(0xFF101010) : Colors.white;

    final textColor = isDarkMode ? Colors.white : const Color(0xFF111111);

    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    final inputColor = isDarkMode
        ? const Color(0xFF1C1C1C)
        : const Color(0xFFF5F5F5);

    final borderColor = isDarkMode ? Colors.white12 : Colors.black12;

    return Theme(
      data: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF111111),
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: toggleTheme,
                    icon: Icon(
                      isDarkMode
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      color: textColor,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'YZ Accessories',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Create an account',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Create your account and start shopping.',
                  style: TextStyle(color: secondaryTextColor, fontSize: 15),
                ),

                const SizedBox(height: 35),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 10),

                          TextField(
                            controller: firstNameController,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'First name',
                              hintStyle: TextStyle(color: secondaryTextColor),
                              filled: true,
                              fillColor: inputColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: textColor,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Name',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 10),

                          TextField(
                            controller: lastNameController,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'Last name',
                              hintStyle: TextStyle(color: secondaryTextColor),
                              filled: true,
                              fillColor: inputColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: textColor,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                Text(
                  'Email',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: secondaryTextColor,
                    ),
                    filled: true,
                    fillColor: inputColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: textColor, width: 1.2),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Password',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: secondaryTextColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: secondaryTextColor,
                      ),
                    ),
                    filled: true,
                    fillColor: inputColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: textColor, width: 1.2),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Confirm Password',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: secondaryTextColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: secondaryTextColor,
                      ),
                    ),
                    filled: true,
                    fillColor: inputColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: textColor, width: 1.2),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textColor,
                      foregroundColor: backgroundColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: backgroundColor,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: secondaryTextColor),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

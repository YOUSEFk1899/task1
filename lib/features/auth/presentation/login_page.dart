import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/auth_remote_data_source.dart';
import '../data/auth_repository_impl.dart';
import 'signup_page.dart';
import '../../products/presentation/product_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

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

    setState(() {
      isLoading = true;
    });

    try {
      await authRepository.login(email: email, password: password);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductScreen()),
      );
    } on DioException catch (e) {
      if (!mounted) return;

      String message = 'Login failed';

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

                const SizedBox(height: 30),

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
                  'Welcome back',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Login to continue shopping with us.',
                  style: TextStyle(color: secondaryTextColor, fontSize: 15),
                ),

                const SizedBox(height: 40),

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
                    hintText: 'Enter your password',
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

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
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
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(child: Divider(color: borderColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: borderColor)),
                  ],
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: secondaryTextColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupPage()),
                        );
                      },
                      child: Text(
                        'Sign Up',
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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/auth_remote_data_source.dart';
import '../data/auth_repository_impl.dart';
import '../../products/presentation/product_screen.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final otpController = TextEditingController();

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
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyEmail() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      showMessage('Please enter the verification code');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authRepository.verifyEmail(email: widget.email, otp: otp);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProductScreen()),
        (route) => false,
      );
    } on DioException catch (e) {
      if (!mounted) return;

      String message = 'Verification failed';

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

                const SizedBox(height: 40),

                Text(
                  'YZ Accessories',

                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Verify your email',

                  style: TextStyle(
                    color: textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Enter the verification code sent to:',

                  style: TextStyle(color: secondaryTextColor, fontSize: 15),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.email,

                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 35),

                Text(
                  'Verification Code',

                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: otpController,

                  keyboardType: TextInputType.number,

                  textAlign: TextAlign.center,

                  maxLength: 6,

                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),

                  decoration: InputDecoration(
                    counterText: '',

                    hintText: '000000',

                    hintStyle: TextStyle(
                      color: secondaryTextColor,
                      letterSpacing: 8,
                    ),

                    filled: true,

                    fillColor: inputColor,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
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
                    onPressed: isLoading ? null : verifyEmail,

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
                            'VERIFY EMAIL',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    'Enter the code you received in your email.',

                    textAlign: TextAlign.center,

                    style: TextStyle(color: secondaryTextColor, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// views/splash_screen.dart
// ========================================
// ENHANCED SPLASH SCREEN - DENGAN ANIMASI & CUSTOM LOGO
// ========================================

import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    
    // Controller untuk icon
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Controller untuk text
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Controller untuk background
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Icon scale animation
    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.elasticOut,
      ),
    );

    // Icon rotation animation (subtle)
    _iconRotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.easeOut,
      ),
    );

    // Text fade animation
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    // Text slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    // Background pulse animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _startAnimations();

    // Navigate to home after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _backgroundController.forward();
    _iconController.forward();
    
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2936),
      body: Stack(
        children: [
          // Animated background circles
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Positioned(
                top: -100 + (_backgroundAnimation.value * 20),
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7AB8FF).withOpacity(
                      0.05 * _backgroundAnimation.value,
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: -150 + (_backgroundAnimation.value * -20),
                left: -50,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7AB8FF).withOpacity(
                      0.03 * _backgroundAnimation.value,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Main content with CUSTOM LOGO
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Custom Logo - Path diperbaiki ke assets/icon/app_icon.png
                AnimatedBuilder(
                  animation: _iconController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _iconScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _iconRotationAnimation.value,
                        child: Image.asset(
                          'assets/icon/app_splash.png',
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback jika logo tidak ditemukan
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF7AB8FF).withOpacity(0.1),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7AB8FF).withOpacity(0.3),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                size: 80,
                                color: Color(0xFF7AB8FF),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 30),
                
                // Animated Text
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: SlideTransition(
                    position: _textSlideAnimation,
                    child: const Text(
                      'Schedio',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                
                // Animated loading indicator
                const SizedBox(height: 50),
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF7AB8FF).withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:schedule_app/models/navigation_item.dart';
import '../controllers/navigation_controller.dart';

class ModernBottomNavbar extends StatefulWidget {
  final NavigationController controller;
  final int currentIndex;
  final VoidCallback? onAddPressed;
  
  const ModernBottomNavbar({
    Key? key,
    required this.controller,
    required this.currentIndex,
    this.onAddPressed,
  }) : super(key: key);

  @override
  State<ModernBottomNavbar> createState() => _ModernBottomNavbarState();
}

class _ModernBottomNavbarState extends State<ModernBottomNavbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode
                      ? [
                          const Color(0xFF2A3947).withOpacity(0.95),
                          const Color(0xFF1E2936),
                        ]
                      : [
                          Colors.white.withOpacity(0.98),
                          const Color(0xFFF8F9FA),
                        ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
            ),
          ),
          
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  widget.controller.items.length,
                  (index) {
                    final item = widget.controller.items[index];
                    if (item.isCenter) {
                      return const SizedBox(width: 60);
                    }
                    return _buildNavItem(item, index, isDarkMode);
                  },
                ),
              ),
            ),
          ),
          
          Positioned(
            top: -25,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) {
                  _animationController.reverse();
                  widget.onAddPressed?.call();
                },
                onTapCancel: () => _animationController.reverse(),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 3.14159,
                        child: Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF7AB8FF),
                                Color(0xFF5A9FE8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7AB8FF).withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item, int index, bool isDarkMode) {
    final isSelected = widget.currentIndex == index;
    
    return Flexible(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(end: isSelected ? 1.0 : 0.0),
        builder: (context, value, child) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print('Navigating to index: $index');
                widget.controller.navigateToIndex(context, index);
              },
              splashColor: const Color(0xFF7AB8FF).withOpacity(0.3),
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 60,
                  maxWidth: 80,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      width: isSelected ? 30 : 0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7AB8FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(isSelected ? 4 : 0),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? const Color(0xFF7AB8FF).withOpacity(0.2)
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: isSelected 
                          ? const Color(0xFF7AB8FF)
                          : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                        size: isSelected ? 26 : 24,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected 
                          ? const Color(0xFF7AB8FF)
                          : (isDarkMode ? Colors.grey[500] : Colors.grey[600]),
                        fontSize: isSelected ? 11 : 10,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
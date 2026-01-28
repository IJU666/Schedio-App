import 'package:flutter/material.dart';

class PageTransition {
  static Route createRoute(Widget page, {TransitionType type = TransitionType.fade}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (type) {
          case TransitionType.fade:
            return FadeTransition(opacity: animation, child: child);
          
          case TransitionType.slide:
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          
          case TransitionType.scale:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
              ),
              child: child,
            );
          
          case TransitionType.slideUp:
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
        }
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

enum TransitionType {
  fade,
  slide,
  scale,
  slideUp,
}
// 📄 lib/widgets/home/carousel_auto_center_wrapper.dart
//
// 🎯 Prevents automatic centering loops by guarding animateToPage.
// Fixes StackOverflow caused by recursive ScrollEnd → animateToPage cycles.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CarouselAutoCenterWrapper extends StatefulWidget {
  final PageController controller;
  final Widget child;

  const CarouselAutoCenterWrapper({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<CarouselAutoCenterWrapper> createState() =>
      _CarouselAutoCenterWrapperState();
}

class _CarouselAutoCenterWrapperState
    extends State<CarouselAutoCenterWrapper> {
  bool _userIsScrolling = false;
  bool _isSnapping = false; // 👈 NEW GUARD

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Track user scroll state
        if (notification is UserScrollNotification) {
          _userIsScrolling =
              notification.direction != ScrollDirection.idle;
        }

        // Only auto-center when user has lifted finger
        if (notification is ScrollEndNotification) {
          if (!_userIsScrolling &&
              !_isSnapping && // 👈 Prevent recursive snapping
              widget.controller.position.haveDimensions) {
            _isSnapping = true;

            final targetPage = widget.controller.page!.round();

            widget.controller.animateToPage(
              targetPage,
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
            ).whenComplete(() {
              _isSnapping = false; // 👈 allow next snap
            });
          }
        }

        return false;
      },
      child: widget.child,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/drag_offset_cubit.dart';

/// Wraps [child] in a draggable card that flies off-screen left or right,
/// either from a drag release past the swipe threshold or from a
/// programmatic call to [SwipeableCardState.swipeLeft] / [swipeRight] (used
/// by the Cancel / Like buttons, which must trigger the exact same action
/// as the equivalent drag gesture).
class SwipeableCard extends StatefulWidget {
  const SwipeableCard({
    super.key,
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  final Widget child;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  @override
  State<SwipeableCard> createState() => SwipeableCardState();
}

class SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  static const _swipeThreshold = 120.0;

  late final AnimationController _controller;
  final _dragOffsetCubit = DragOffsetCubit();
  Animation<Offset>? _offsetAnimation;
  bool _dragging = false;

  Offset get _dragOffset => _dragOffsetCubit.state;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..addListener(() {
          final animation = _offsetAnimation;
          if (animation != null) _dragOffsetCubit.update(animation.value);
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dragOffsetCubit.close();
    super.dispose();
  }

  void swipeLeft() => _animateSwipe(right: false);
  void swipeRight() => _animateSwipe(right: true);

  Future<void> _animateSwipe({required bool right}) async {
    if (_controller.isAnimating) return;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final end = Offset(
      right ? screenWidth * 1.6 : -screenWidth * 1.6,
      _dragOffset.dy - 40,
    );
    _offsetAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    await _controller.forward(from: 0);
    _offsetAnimation = null;
    right ? widget.onSwipeRight() : widget.onSwipeLeft();
    if (mounted) _dragOffsetCubit.update(Offset.zero);
  }

  // Horizontal-only drag (not onPan) so vertical drags fall through to the
  // profile's own inner scroll view instead of being captured here.
  void _onHorizontalDragStart(DragStartDetails details) {
    if (_controller.isAnimating) return;
    _dragging = true;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_dragging) return;
    _dragOffsetCubit.update(_dragOffset + Offset(details.delta.dx, 0));
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!_dragging) return;
    _dragging = false;
    if (_dragOffset.dx.abs() > _swipeThreshold) {
      _animateSwipe(right: _dragOffset.dx > 0);
      return;
    }
    _offsetAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: BlocBuilder<DragOffsetCubit, Offset>(
        bloc: _dragOffsetCubit,
        builder: (context, dragOffset) {
          final angle = dragOffset.dx / 800;
          return Transform.translate(
            offset: dragOffset,
            child: Transform.rotate(angle: angle, child: widget.child),
          );
        },
      ),
    );
  }
}

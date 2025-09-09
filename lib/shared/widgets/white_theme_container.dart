import 'package:flutter/material.dart';
import '../../core/constants/white_theme_colors.dart';

class WhiteThemeContainer extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool elevated;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const WhiteThemeContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.elevated = true,
    this.borderRadius = 12,
    this.onTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<WhiteThemeContainer> createState() => _WhiteThemeContainerState();
}

class _WhiteThemeContainerState extends State<WhiteThemeContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      } : null,
      onTapUp: widget.onTap != null ? (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap!();
      } : null,
      onTapCancel: widget.onTap != null ? () {
        setState(() => _isPressed = false);
        _controller.reverse();
      } : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final scale = 1.0 - (0.02 * _controller.value);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              padding: widget.padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? WhiteThemeColors.pureWhite,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: WhiteThemeColors.borderGray,
                  width: 1,
                ),
                boxShadow: widget.elevated ? [
                  BoxShadow(
                    color: _isPressed 
                        ? WhiteThemeColors.mediumShadow 
                        : WhiteThemeColors.lightShadow,
                    blurRadius: _isPressed ? 8 : 12,
                    offset: _isPressed 
                        ? const Offset(0, 2) 
                        : const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ] : null,
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

class WhiteThemeButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isPrimary;
  final double width;
  final double height;
  final bool enabled;

  const WhiteThemeButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.isPrimary = true,
    this.width = 120,
    this.height = 50,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<WhiteThemeButton> createState() => _WhiteThemeButtonState();
}

class _WhiteThemeButtonState extends State<WhiteThemeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      } : null,
      onTapUp: widget.enabled ? (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onPressed?.call();
      } : null,
      onTapCancel: widget.enabled ? () {
        setState(() => _isPressed = false);
        _controller.reverse();
      } : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final scale = 1.0 - (0.03 * _controller.value);
          final opacity = widget.enabled ? 1.0 : 0.6;
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: widget.isPrimary
                    ? WhiteThemeColors.primaryButtonGradient
                    : WhiteThemeColors.secondaryButtonGradient,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: widget.isPrimary
                        ? WhiteThemeColors.softBlue.withOpacity(0.3 * opacity)
                        : WhiteThemeColors.mediumShadow,
                    blurRadius: _isPressed ? 8 : 12,
                    offset: _isPressed 
                        ? const Offset(0, 2) 
                        : const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: widget.isPrimary 
                        ? WhiteThemeColors.pureWhite 
                        : WhiteThemeColors.primaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WhiteThemeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const WhiteThemeCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteThemeContainer(
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/models/chat_message.dart';
import '../../../../core/constants/white_theme_colors.dart';
import '../../../../shared/widgets/white_theme_container.dart';

class WhiteThemeMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback? onLongPress;
  final VoidCallback? onSpeakPressed;
  final bool isPlaying;

  const WhiteThemeMessageBubble({
    Key? key,
    required this.message,
    this.onLongPress,
    this.onSpeakPressed,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  State<WhiteThemeMessageBubble> createState() => _WhiteThemeMessageBubbleState();
}

class _WhiteThemeMessageBubbleState extends State<WhiteThemeMessageBubble>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.isPlaying) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(WhiteThemeMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: widget.message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.message.isUser) ...[
            _buildAvatar(),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: _buildMessageContent(),
          ),
          if (widget.message.isUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(),
          ],
        ],
      ),
    )
    .animate(controller: _slideController)
    .slideX(
      begin: widget.message.isUser ? 0.2 : -0.2,
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    )
    .fadeIn(duration: 300.ms);
  }

  Widget _buildAvatar() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = widget.isPlaying && !widget.message.isUser 
            ? 1.0 + (0.05 * _pulseController.value)
            : 1.0;
            
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.message.isUser
                  ? WhiteThemeColors.primaryButtonGradient
                  : LinearGradient(
                      colors: [
                        WhiteThemeColors.lightBlue,
                        WhiteThemeColors.softBlue,
                      ],
                    ),
              boxShadow: [
                BoxShadow(
                  color: widget.message.isUser
                      ? WhiteThemeColors.accentBlue.withOpacity(0.3)
                      : WhiteThemeColors.lightBlue.withOpacity(0.3),
                  blurRadius: widget.isPlaying ? 12 : 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              widget.message.isUser ? Icons.person : Icons.smart_toy,
              color: Colors.white,
              size: 22,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageContent() {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.message.isUser 
              ? WhiteThemeColors.accentBlue
              : WhiteThemeColors.pureWhite,
          borderRadius: BorderRadius.circular(20),
          border: widget.message.isUser 
              ? null 
              : Border.all(color: WhiteThemeColors.borderGray),
          boxShadow: [
            BoxShadow(
              color: widget.message.isUser
                  ? WhiteThemeColors.accentBlue.withOpacity(0.2)
                  : WhiteThemeColors.lightShadow,
              blurRadius: widget.isPlaying ? 15 : 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message text
            SelectableText(
              widget.message.text,
              style: TextStyle(
                color: widget.message.isUser 
                    ? WhiteThemeColors.pureWhite
                    : WhiteThemeColors.primaryText,
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Bottom row with time and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(widget.message.timestamp),
                  style: TextStyle(
                    color: widget.message.isUser
                        ? WhiteThemeColors.pureWhite.withOpacity(0.8)
                        : WhiteThemeColors.lightText,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                
                // Voice button for bot messages
                if (!widget.message.isUser && widget.onSpeakPressed != null)
                  GestureDetector(
                    onTap: widget.onSpeakPressed,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.isPlaying
                                ? WhiteThemeColors.successGreen
                                : WhiteThemeColors.lightGray,
                            boxShadow: [
                              BoxShadow(
                                color: widget.isPlaying
                                    ? WhiteThemeColors.successGreen.withOpacity(0.3)
                                    : WhiteThemeColors.lightShadow,
                                blurRadius: widget.isPlaying ? 8 : 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.isPlaying ? Icons.stop : Icons.volume_up,
                            color: widget.isPlaying
                                ? Colors.white
                                : WhiteThemeColors.secondaryText,
                            size: 16,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'เมื่อสักครู่';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
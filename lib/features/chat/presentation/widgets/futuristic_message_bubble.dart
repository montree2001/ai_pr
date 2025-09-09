import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/models/chat_message.dart';
import '../../../../core/constants/futuristic_colors.dart';
import '../../../../shared/widgets/holographic_container.dart';

class FuturisticMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback? onLongPress;
  final VoidCallback? onSpeakPressed;
  final bool isPlaying;

  const FuturisticMessageBubble({
    Key? key,
    required this.message,
    this.onLongPress,
    this.onSpeakPressed,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  State<FuturisticMessageBubble> createState() => _FuturisticMessageBubbleState();
}

class _FuturisticMessageBubbleState extends State<FuturisticMessageBubble>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
  void didUpdateWidget(FuturisticMessageBubble oldWidget) {
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
      begin: widget.message.isUser ? 0.3 : -0.3,
      duration: 600.ms,
      curve: Curves.elasticOut,
    )
    .fadeIn(duration: 400.ms);
  }

  Widget _buildAvatar() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = widget.isPlaying && !widget.message.isUser 
            ? 1.0 + (0.1 * _pulseController.value)
            : 1.0;
            
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.message.isUser
                  ? const LinearGradient(
                      colors: [
                        FuturisticColors.neonPink,
                        FuturisticColors.neonPurple,
                      ],
                    )
                  : FuturisticColors.holographicGradient,
              boxShadow: [
                BoxShadow(
                  color: widget.message.isUser
                      ? FuturisticColors.neonPink.withOpacity(0.5)
                      : FuturisticColors.neonCyan.withOpacity(0.5),
                  blurRadius: widget.isPlaying ? 15 : 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              widget.message.isUser ? Icons.person : Icons.smart_toy,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageContent() {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: HolographicContainer(
        animated: !widget.message.isUser,
        glowing: widget.isPlaying,
        borderRadius: 25,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message text
            SelectableText(
              widget.message.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w400,
                shadows: [
                  Shadow(
                    color: widget.message.isUser
                        ? FuturisticColors.neonPink.withOpacity(0.3)
                        : FuturisticColors.neonCyan.withOpacity(0.3),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Bottom row with time and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(widget.message.timestamp),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                FuturisticColors.neonGreen
                                    .withOpacity(widget.isPlaying ? 0.8 : 0.3),
                                FuturisticColors.neonBlue
                                    .withOpacity(widget.isPlaying ? 0.8 : 0.3),
                              ],
                            ),
                          ),
                          child: Icon(
                            widget.isPlaying ? Icons.stop : Icons.volume_up,
                            color: Colors.white,
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
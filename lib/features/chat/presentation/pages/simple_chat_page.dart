import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/chat_message.dart';
import '../../../../core/constants/white_theme_colors.dart';
import '../../../../shared/widgets/white_theme_container.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class SimpleChatPage extends StatefulWidget {
  const SimpleChatPage({Key? key}) : super(key: key);

  @override
  State<SimpleChatPage> createState() => _SimpleChatPageState();
}

class _SimpleChatPageState extends State<SimpleChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // เริ่มต้น chat
    context.read<ChatBloc>().add(const ChatStarted());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(text));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteThemeColors.softWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildChatArea()),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: WhiteThemeColors.pureWhite,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: WhiteThemeColors.blueGradient,
              boxShadow: [
                BoxShadow(
                  color: WhiteThemeColors.softBlue.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'SmartPR Assistant',
            style: TextStyle(
              color: WhiteThemeColors.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: WhiteThemeColors.borderGray,
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        if (state is ChatInitial) {
          return _buildWelcomeScreen();
        } else if (state is ChatLoading) {
          return _buildLoadingScreen();
        } else if (state is ChatLoaded) {
          return _buildMessageList(state.messages);
        } else if (state is ChatError) {
          return _buildErrorScreen(state.message);
        }
        return const Center(
          child: Text('กำลังเตรียมระบบแชท...'),
        );
      },
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: WhiteThemeColors.blueGradient,
                boxShadow: [
                  BoxShadow(
                    color: WhiteThemeColors.softBlue.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'ยินดีต้อนรับสู่ SmartPR Assistant',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: WhiteThemeColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'ผู้ช่วยอัจฉริยะสำหรับวิทยาลัยเทคนิคประสาท\nพร้อมช่วยเหลือคุณในทุกเรื่อง',
              style: TextStyle(
                fontSize: 16,
                color: WhiteThemeColors.secondaryText,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildQuickStartButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStartButtons() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildQuickButton('สวัสดีครับ', Icons.waving_hand),
        _buildQuickButton('เกี่ยวกับวิทยาลัย', Icons.school),
        _buildQuickButton('ช่วยเหลือ', Icons.help_outline),
        _buildQuickButton('วิธีใช้งาน', Icons.info_outline),
      ],
    );
  }

  Widget _buildQuickButton(String text, IconData icon) {
    return WhiteThemeButton(
      onPressed: () {
        _messageController.text = text;
        _sendMessage();
      },
      width: 140,
      height: 50,
      isPrimary: false,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(WhiteThemeColors.softBlue),
          ),
          SizedBox(height: 20),
          Text(
            'กำลังโหลด...',
            style: TextStyle(
              color: WhiteThemeColors.secondaryText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: WhiteThemeCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: WhiteThemeColors.errorRed,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'เกิดข้อผิดพลาด',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: WhiteThemeColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  color: WhiteThemeColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              WhiteThemeButton(
                onPressed: () {
                  context.read<ChatBloc>().add(const ChatStarted());
                },
                child: const Text('ลองใหม่อีกครั้ง'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return _buildWelcomeScreen();
    }

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final isTyping = state is ChatLoaded && state.isTyping;
        
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length + (isTyping ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == messages.length && isTyping) {
              return _buildTypingIndicator();
            }
            final message = messages[index];
            return _buildMessageBubble(message);
          },
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(false),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: WhiteThemeColors.pureWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WhiteThemeColors.borderGray),
              boxShadow: [
                BoxShadow(
                  color: WhiteThemeColors.lightShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(200),
                const SizedBox(width: 4),
                _buildTypingDot(400),
                const SizedBox(width: 8),
                const Text(
                  'กำลังพิมพ์...',
                  style: TextStyle(
                    color: WhiteThemeColors.lightText,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        final animationValue = (value * 4 + delay / 500) % 1.0;
        final opacity = 0.3 + (0.7 * (1 - (animationValue - 0.5).abs() * 2).clamp(0.0, 1.0));
        
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: WhiteThemeColors.softBlue.withOpacity(opacity),
          ),
        );
      },
      onEnd: () {
        // Repeat the animation
        setState(() {});
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            _buildAvatar(false),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? WhiteThemeColors.softBlue
                    : WhiteThemeColors.pureWhite,
                borderRadius: BorderRadius.circular(20),
                border: message.isUser 
                    ? null 
                    : Border.all(color: WhiteThemeColors.borderGray),
                boxShadow: [
                  BoxShadow(
                    color: message.isUser
                        ? WhiteThemeColors.softBlue.withOpacity(0.2)
                        : WhiteThemeColors.lightShadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    message.text,
                    style: TextStyle(
                      color: message.isUser 
                          ? Colors.white
                          : WhiteThemeColors.primaryText,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white.withOpacity(0.8)
                          : WhiteThemeColors.lightText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(true),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isUser
            ? WhiteThemeColors.blueGradient
            : const LinearGradient(
                colors: [
                  WhiteThemeColors.lightBlue,
                  WhiteThemeColors.softBlue,
                ],
              ),
        boxShadow: [
          BoxShadow(
            color: WhiteThemeColors.softBlue.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: WhiteThemeColors.pureWhite,
        border: Border(
          top: BorderSide(color: WhiteThemeColors.borderGray),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: WhiteThemeColors.lightGray,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: WhiteThemeColors.borderGray),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'พิมพ์ข้อความ...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: WhiteThemeColors.hintText),
                  ),
                  style: const TextStyle(
                    color: WhiteThemeColors.primaryText,
                    fontSize: 16,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            WhiteThemeButton(
              onPressed: _sendMessage,
              width: 56,
              height: 56,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/chat_message.dart';
import '../../../../core/services/voice_service.dart';
import '../../../../core/constants/white_theme_colors.dart';
import '../../../../shared/widgets/white_theme_container.dart';
import '../widgets/white_theme_message_bubble.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class WhiteThemeChatPage extends StatefulWidget {
  const WhiteThemeChatPage({Key? key}) : super(key: key);

  @override
  State<WhiteThemeChatPage> createState() => _WhiteThemeChatPageState();
}

class _WhiteThemeChatPageState extends State<WhiteThemeChatPage> 
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final VoiceService _voiceService = VoiceService();
  
  bool _isListening = false;
  bool _isPlaying = false;
  String? _currentPlayingMessageId;
  
  late AnimationController _breatheController;
  late AnimationController _pulseController;
  late AnimationController _micController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVoiceService();
  }

  void _initializeAnimations() {
    _breatheController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _micController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  void _initializeVoiceService() async {
    await _voiceService.initialize();
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _pulseController.dispose();
    _micController.dispose();
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
    if (_messageController.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(_messageController.text.trim()));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _startListening() async {
    if (!_isListening) {
      setState(() => _isListening = true);
      _micController.forward();
      _pulseController.repeat(reverse: true);
      
      await _voiceService.startListening(
        onResult: (result) {
          if (result.isNotEmpty) {
            _messageController.text = result;
          }
        },
      );
      
      setState(() => _isListening = false);
      _micController.reverse();
      _pulseController.stop();
      _pulseController.reset();
    } else {
      _voiceService.stopListening();
      setState(() => _isListening = false);
      _micController.reverse();
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  void _speakMessage(String messageId, String text) async {
    if (_isPlaying && _currentPlayingMessageId == messageId) {
      await _voiceService.stopSpeaking();
      setState(() {
        _isPlaying = false;
        _currentPlayingMessageId = null;
      });
    } else {
      await _voiceService.stopSpeaking();
      setState(() {
        _isPlaying = true;
        _currentPlayingMessageId = messageId;
      });
      
      await _voiceService.speak(text);
      
      setState(() {
        _isPlaying = false;
        _currentPlayingMessageId = null;
      });
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
          AnimatedBuilder(
            animation: _breatheController,
            builder: (context, child) {
              final scale = 1.0 + (0.05 * _breatheController.value);
              return Transform.scale(
                scale: scale,
                child: Container(
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
                    color: WhiteThemeColors.pureWhite,
                    size: 20,
                  ),
                ),
              );
            },
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
        return const SizedBox.shrink();
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
            AnimatedBuilder(
              animation: _breatheController,
              builder: (context, child) {
                final scale = 1.0 + (0.1 * _breatheController.value);
                return Transform.scale(
                  scale: scale,
                  child: Container(
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
                      color: WhiteThemeColors.pureWhite,
                      size: 60,
                    ),
                  ),
                );
              },
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
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.chat, 'text': 'เริ่มต้นสนทนา', 'message': 'สวัสดีครับ'},
      {'icon': Icons.help, 'text': 'คำถามทั่วไป', 'message': 'มีคำถามอะไรไหม'},
      {'icon': Icons.school, 'text': 'เกี่ยวกับวิทยาลัย', 'message': 'บอกเกี่ยวกับวิทยาลัยเทคนิคประสาท'},
      {'icon': Icons.info, 'text': 'วิธีใช้งาน', 'message': 'สอนวิธีใช้งานระบบหน่อย'},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: actions.map((action) => WhiteThemeButton(
        onPressed: () {
          _messageController.text = action['message'] as String;
          _sendMessage();
        },
        width: 160,
        height: 60,
        isPrimary: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action['icon'] as IconData, size: 20),
            const SizedBox(height: 4),
            Text(
              action['text'] as String,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )).toList(),
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
              Text(
                'เกิดข้อผิดพลาด',
                style: const TextStyle(
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
                onPressed: () => context.read<ChatBloc>().add(const ChatStarted()),
                child: const Text('ลองใหม่อีกครั้ง'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return WhiteThemeMessageBubble(
          message: message,
          onLongPress: () {
            // Handle long press (copy message, etc.)
          },
          onSpeakPressed: !message.isUser ? () => _speakMessage(
            message.id,
            message.text,
          ) : null,
          isPlaying: _isPlaying && _currentPlayingMessageId == message.id,
        );
      },
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
              child: WhiteThemeContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevated: false,
                backgroundColor: WhiteThemeColors.lightGray,
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'พิมพ์ข้อความหรือใช้เสียง...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: WhiteThemeColors.hintText),
                  ),
                  style: const TextStyle(
                    color: WhiteThemeColors.primaryText,
                    fontSize: 16,
                  ),
                  maxLines: null,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildVoiceButton(),
            const SizedBox(width: 8),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceButton() {
    return GestureDetector(
      onTap: _startListening,
      child: AnimatedBuilder(
        animation: Listenable.merge([_micController, _pulseController]),
        builder: (context, child) {
          final scale = 1.0 + (0.1 * _micController.value) + 
                         (_isListening ? 0.05 * _pulseController.value : 0);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _isListening 
                    ? WhiteThemeColors.blueGradient
                    : const LinearGradient(colors: [
                        WhiteThemeColors.lightGray,
                        WhiteThemeColors.mediumGray,
                      ]),
                boxShadow: [
                  BoxShadow(
                    color: _isListening
                        ? WhiteThemeColors.softBlue.withOpacity(0.4)
                        : WhiteThemeColors.mediumShadow,
                    blurRadius: _isListening ? 15 : 8,
                    spreadRadius: _isListening ? 2 : 0,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening 
                    ? WhiteThemeColors.pureWhite
                    : WhiteThemeColors.secondaryText,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSendButton() {
    return WhiteThemeButton(
      onPressed: _sendMessage,
      width: 56,
      height: 56,
      child: const Icon(
        Icons.send,
        color: WhiteThemeColors.pureWhite,
        size: 20,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/white_theme_colors.dart';
import '../../../../shared/widgets/white_theme_container.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'dart:math' as math;

class VoiceChatPage extends StatefulWidget {
  const VoiceChatPage({Key? key}) : super(key: key);

  @override
  State<VoiceChatPage> createState() => _VoiceChatPageState();
}

class _VoiceChatPageState extends State<VoiceChatPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _breatheController;
  
  bool _isListening = false;
  bool _isConnected = false;
  bool _isSpeaking = false;
  
  List<double> _audioLevels = List.filled(50, 0.0);
  int _currentLevel = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeVoiceChat();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _breatheController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _initializeVoiceChat() {
    context.read<ChatBloc>().add(const ChatStarted());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _startListening();
      } else {
        _stopListening();
      }
    });
  }

  void _startListening() {
    // Start voice recognition
    _pulseController.repeat(reverse: true);
    // Simulate audio levels
    _simulateAudioInput();
  }

  void _stopListening() {
    _pulseController.stop();
    _pulseController.reset();
  }

  void _simulateAudioInput() {
    if (_isListening) {
      setState(() {
        _currentLevel = (_currentLevel + 1) % _audioLevels.length;
        _audioLevels[_currentLevel] = 
            0.1 + (math.Random().nextDouble() * 0.9);
      });
      
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_isListening) _simulateAudioInput();
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
          Expanded(
            child: _buildVoiceInterface(),
          ),
          _buildControlPanel(),
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
              Icons.record_voice_over,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Voice Assistant',
                style: TextStyle(
                  color: WhiteThemeColors.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Gemini 2.5 Native Audio',
                style: TextStyle(
                  color: WhiteThemeColors.lightText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isConnected 
                ? WhiteThemeColors.successGreen.withOpacity(0.1)
                : WhiteThemeColors.errorRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isConnected 
                  ? WhiteThemeColors.successGreen
                  : WhiteThemeColors.errorRed,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isConnected 
                      ? WhiteThemeColors.successGreen
                      : WhiteThemeColors.errorRed,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _isConnected ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  color: _isConnected 
                      ? WhiteThemeColors.successGreen
                      : WhiteThemeColors.errorRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: WhiteThemeColors.borderGray,
        ),
      ),
    );
  }

  Widget _buildVoiceInterface() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main voice visualizer
          _buildVoiceVisualizer(),
          const SizedBox(height: 60),
          
          // Status text
          _buildStatusText(),
          const SizedBox(height: 40),
          
          // Audio levels
          if (_isListening) _buildAudioLevels(),
        ],
      ),
    );
  }

  Widget _buildVoiceVisualizer() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseController,
        _waveController,
        _breatheController,
      ]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer rings
            ...List.generate(3, (index) {
              final delay = index * 0.3;
              final scale = 1.0 + 
                  (_breatheController.value * 0.2) + 
                  ((_waveController.value + delay) % 1.0 * 0.1);
              final opacity = _isListening
                  ? 0.1 - (index * 0.03)
                  : 0.05 - (index * 0.015);
              
              return Transform.scale(
                scale: scale + (index * 0.3),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: WhiteThemeColors.softBlue.withOpacity(opacity),
                      width: 2,
                    ),
                  ),
                ),
              );
            }),
            
            // Main circle
            Transform.scale(
              scale: 1.0 + (_pulseController.value * 0.1),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _isListening
                      ? const LinearGradient(
                          colors: [
                            WhiteThemeColors.successGreen,
                            WhiteThemeColors.softBlue,
                          ],
                        )
                      : WhiteThemeColors.blueGradient,
                  boxShadow: [
                    BoxShadow(
                      color: _isListening
                          ? WhiteThemeColors.successGreen.withOpacity(0.4)
                          : WhiteThemeColors.softBlue.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusText() {
    String statusText;
    Color statusColor;
    
    if (!_isConnected) {
      statusText = 'Tap to connect and start conversation';
      statusColor = WhiteThemeColors.lightText;
    } else if (_isListening) {
      statusText = 'Listening... speak now';
      statusColor = WhiteThemeColors.successGreen;
    } else if (_isSpeaking) {
      statusText = 'AI is speaking...';
      statusColor = WhiteThemeColors.softBlue;
    } else {
      statusText = 'Tap and hold to talk';
      statusColor = WhiteThemeColors.primaryText;
    }
    
    return Column(
      children: [
        Text(
          statusText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: statusColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Natural conversation with AI',
          style: TextStyle(
            fontSize: 14,
            color: WhiteThemeColors.lightText,
          ),
        ),
      ],
    );
  }

  Widget _buildAudioLevels() {
    return Container(
      height: 60,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_audioLevels.length ~/ 2, (index) {
          final level = _audioLevels[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 3,
            height: 10 + (level * 40),
            decoration: BoxDecoration(
              color: WhiteThemeColors.successGreen.withOpacity(0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: WhiteThemeColors.pureWhite,
        border: Border(
          top: BorderSide(color: WhiteThemeColors.borderGray),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Connection toggle
            if (!_isConnected) ...[
              WhiteThemeButton(
                onPressed: () {
                  setState(() => _isConnected = true);
                },
                width: double.infinity,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone, color: Colors.white),
                    const SizedBox(width: 12),
                    const Text(
                      'Connect to Voice Assistant',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Voice controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute button
                  _buildControlButton(
                    icon: Icons.mic_off,
                    label: 'Mute',
                    isActive: false,
                    onPressed: () {
                      // Toggle mute
                    },
                  ),
                  
                  // Main talk button
                  GestureDetector(
                    onTapDown: (_) => _toggleListening(),
                    onTapUp: (_) => _toggleListening(),
                    onTapCancel: () => _toggleListening(),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _isListening
                            ? const LinearGradient(
                                colors: [
                                  WhiteThemeColors.successGreen,
                                  WhiteThemeColors.softBlue,
                                ],
                              )
                            : WhiteThemeColors.blueGradient,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening
                                ? WhiteThemeColors.successGreen
                                : WhiteThemeColors.softBlue).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  
                  // Settings button
                  _buildControlButton(
                    icon: Icons.settings,
                    label: 'Settings',
                    isActive: false,
                    onPressed: () {
                      _showSettingsDialog();
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Disconnect button
              TextButton(
                onPressed: () {
                  setState(() {
                    _isConnected = false;
                    _isListening = false;
                  });
                },
                child: const Text(
                  'Disconnect',
                  style: TextStyle(
                    color: WhiteThemeColors.errorRed,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? WhiteThemeColors.softBlue
                : WhiteThemeColors.lightGray,
            boxShadow: [
              BoxShadow(
                color: WhiteThemeColors.lightShadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: isActive
                  ? Colors.white
                  : WhiteThemeColors.secondaryText,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: WhiteThemeColors.secondaryText,
          ),
        ),
      ],
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: WhiteThemeColors.pureWhite,
        title: const Text(
          'Voice Settings',
          style: TextStyle(color: WhiteThemeColors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Voice Volume'),
              subtitle: Slider(
                value: 0.8,
                onChanged: (value) {
                  // Adjust volume
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Speech Speed'),
              subtitle: Slider(
                value: 0.5,
                onChanged: (value) {
                  // Adjust speed
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: const Text('Thai'),
              onTap: () {
                // Show language picker
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/futuristic_colors.dart';
import '../../../../core/services/voice_service.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onResult;
  final VoidCallback? onStartListening;
  final VoidCallback? onStopListening;

  const VoiceInputWidget({
    Key? key,
    required this.onResult,
    this.onStartListening,
    this.onStopListening,
  }) : super(key: key);

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  final VoiceService _voiceService = VoiceService();
  
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  
  bool _isListening = false;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeOut,
    ));
    
    _initializeVoiceService();
  }
  
  Future<void> _initializeVoiceService() async {
    await _voiceService.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    if (!_voiceService.speechEnabled) return;
    
    setState(() {
      _isListening = true;
      _currentText = '';
    });
    
    _pulseController.repeat(reverse: true);
    widget.onStartListening?.call();
    
    await _voiceService.startListening(
      onResult: (result) {
        setState(() {
          _currentText = result;
        });
        
        // Trigger wave animation on speech recognition
        _waveController.forward().then((_) {
          _waveController.reset();
        });
      },
    );
    
    // Auto-stop after speech is detected and finalized
    await Future.delayed(const Duration(seconds: 1));
    if (_currentText.isNotEmpty) {
      widget.onResult(_currentText);
      await _stopListening();
    }
  }

  Future<void> _stopListening() async {
    await _voiceService.stopListening();
    _pulseController.stop();
    _pulseController.reset();
    
    setState(() {
      _isListening = false;
    });
    
    widget.onStopListening?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Listening text display
          if (_isListening) ...[
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    FuturisticColors.darkPanel.withOpacity(0.3),
                    FuturisticColors.darkGlass.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: FuturisticColors.neonGreen.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _currentText.isEmpty ? 'กำลังฟัง...' : _currentText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          
          // Voice input button with animations
          GestureDetector(
            onTap: _voiceService.speechEnabled ? _toggleListening : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer pulse animation
                if (_isListening)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: FuturisticColors.neonGreen.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                
                // Wave effect
                if (_isListening)
                  ...List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _waveAnimation,
                      builder: (context, child) {
                        final delay = index * 0.2;
                        final animationValue = (_waveAnimation.value - delay).clamp(0.0, 1.0);
                        
                        return Transform.scale(
                          scale: 1.0 + (animationValue * 0.8),
                          child: Container(
                            width: 100 + (index * 15),
                            height: 100 + (index * 15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FuturisticColors.neonCyan
                                    .withOpacity(0.4 * (1 - animationValue)),
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                
                // Main button
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _isListening
                        ? const LinearGradient(
                            colors: [
                              FuturisticColors.neonGreen,
                              FuturisticColors.neonBlue,
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              FuturisticColors.neonCyan.withOpacity(0.7),
                              FuturisticColors.neonPurple.withOpacity(0.7),
                            ],
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: _isListening
                            ? FuturisticColors.neonGreen.withOpacity(0.6)
                            : FuturisticColors.neonCyan.withOpacity(0.4),
                        blurRadius: _isListening ? 25 : 15,
                        spreadRadius: _isListening ? 5 : 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          )
          .animate(target: _voiceService.speechEnabled ? 1 : 0)
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.8, 0.8)),
          
          // Status text
          const SizedBox(height: 16),
          Text(
            _isListening
                ? 'แตะเพื่อหยุดฟัง'
                : _voiceService.speechEnabled
                    ? 'แตะเพื่อพูด'
                    : 'ไมโครโฟนไม่พร้อมใช้งาน',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
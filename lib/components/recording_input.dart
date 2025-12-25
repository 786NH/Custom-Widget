import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

enum VoiceInputState {
  /// Initial state, ready to start recording.
  idle,

  /// Actively recording audio.
  recording,

  /// Recording is temporarily paused.
  paused,

  /// Recording has been stopped. (User explicitly stopped it)
  stopped,
}

class RecordingInputWidget extends StatefulWidget {
  final Function(String) audioConfirmed;
  final bool isRecord;
  final bool isLoading;
  final bool isEndOfFlow;
  final bool isLast;
  final Function() endOfFlowAction;
  final bool isFollowUpButtonVisible;

  const RecordingInputWidget({
    super.key,
    required this.audioConfirmed,
    required this.isLoading,
    required this.endOfFlowAction,
    required this.isEndOfFlow,
    this.isRecord = false,
    this.isLast = false,
    required this.isFollowUpButtonVisible,
  });

  @override
  State<RecordingInputWidget> createState() => _RecordingInputWidgetState();
}

VoiceInputState _currentState = VoiceInputState.idle;

class _RecordingInputWidgetState extends State<RecordingInputWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final _audioRecorder = AudioRecorder(); // Instance of Record class
  String? _audioFilePath; // To store the path of the recorded audio file

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    // Dispose the audio recorder
    _animationController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        _audioFilePath =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3';

        await _audioRecorder.start(
          RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
          path: _audioFilePath!,
        );
        setState(() {
          _currentState = VoiceInputState.recording;
        });
      }
    } catch (e) {
      log("Error starting recording: $e");
    }
  }

  /// Handles the action to pause recording.
  void _pauseRecording() async {
    try {
      if (await _audioRecorder.isRecording()) {
        await _audioRecorder.pause();
        setState(() {
          _currentState = VoiceInputState.paused;
        });
      }
    } catch (e) {
      log("Error pausing recording: $e");
    }
  }

  /// Handles the action to resume recording.
  void _resumeRecording() async {
    try {
      if (await _audioRecorder.isPaused()) {
        await _audioRecorder.resume();
        setState(() {
          _currentState = VoiceInputState.recording;
        });
      }
    } catch (e) {
      log("Error resuming recording: $e");
    }
  }

  /// Handles the action to stop recording.
  /// This implies the user has finished the current recording session.
  void _stopRecording() async {
    try {
      if (await _audioRecorder.isRecording() ||
          await _audioRecorder.isPaused()) {
        final path = await _audioRecorder.stop();
        setState(() {
          _currentState = VoiceInputState.stopped; // Transition to stopped
          _audioFilePath = path; // Update with the final path
        });
        if (_audioFilePath != null) {
          widget.audioConfirmed(
            _audioFilePath!,
          ); // Pass the file path for processing
        }
      }
    } catch (e) {
      log("Error stopping recording: $e");
    }
  }

  /// Handles the action to reset the recording state to idle.
  /// This is used after a recording has been stopped, to start a new one.
  void _resetRecording() async {
    try {
      if (_audioFilePath != null && File(_audioFilePath!).existsSync()) {
        await File(_audioFilePath!).delete();
        _audioFilePath = null;
        log("Deleted previous recording: $_audioFilePath");
      }
      setState(() {
        _currentState = VoiceInputState.idle;
      });
      log("Recording state reset to idle (ready for new recording)");
    } catch (e) {
      log("Error resetting recording state: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.4.w, vertical: 14.8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //_buildCurrentStateWidget(),
          Gap(20.h),

          // recording footer
          _recordingFooter(
            context,
            onRecord: () {
              if (_currentState == VoiceInputState.idle) {
                _startRecording();
              } else if (_currentState == VoiceInputState.recording) {
                _pauseRecording();
              } else if (_currentState == VoiceInputState.paused) {
                _resumeRecording();
              }
            },
            onRestart: () {
              _resetRecording();
            },
            onEndChat: () {
              if (_currentState == VoiceInputState.recording ||
                  _currentState == VoiceInputState.paused) {
                _stopRecording();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton() {
    switch (_currentState) {
      case VoiceInputState.idle:
        return _recordButton(context);

      case VoiceInputState.recording:
        return _recordButton(context);

      case VoiceInputState.paused:
        return _pauseButton(context);

      case VoiceInputState.stopped:
        return _inactiverRecordButton(context);
    }
  }

  Widget _recordingFooter(
    BuildContext context, {
    required VoidCallback onRecord,
    required VoidCallback onRestart,
    required VoidCallback onEndChat,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// Restart
          _ActionItem(
            icon: Icons.refresh,
            label: "Restart",
            color: Colors.grey,
            onTap: onRestart,
          ),

          /// Record (SPECIAL UI)
          GestureDetector(onTap: onRecord, child: widget.isRecord? _buildCenterButton() : _inactiverRecordButton(context)),

          /// End Chat
          _ActionItem(
            icon: Icons.circle,
            label: "End Chat",
            color: Colors.red,
            onTap: onEndChat,
          ),
        ],
      ),
    );
  }
}

Widget _inactiverRecordButton(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.mic, size: 34.sp, color: Colors.grey),
      SizedBox(height: 6.h),
      Text(
        "Record",
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Widget _recordButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.1),
      borderRadius: BorderRadius.circular(30.r),
    ),
    child: Column(
      children: [
        Icon(
          Icons.graphic_eq, // waveform icon
          color: Colors.blue,
          size: 34.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          "Record",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget _pauseButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.1),
      borderRadius: BorderRadius.circular(30.r),
    ),
    child: Column(
      children: [
        Icon(
          Icons.pause, // waveform icon
          color: Colors.blue,
          size: 34.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          "Resume",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool showDot;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 34.sp, color: color),
              if (showDot)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 10.sp,
                    width: 10.sp,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

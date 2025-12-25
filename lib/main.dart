import 'package:custom_widget/components/recording_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).orientation == Orientation.portrait
          ? const Size(800, 1220)
          : const Size(1280, 740),
      builder: (context, child) {
        return MaterialApp(debugShowCheckedModeBanner: false, home: child);
      },
      child: const MyHomePage(), // or your first screen
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Center(
            child: RecordingInputWidget(
              isRecord: false,
              audioConfirmed: (audioPath) {},
              isLoading: false,
              isEndOfFlow: false,
              endOfFlowAction: () {},
              isFollowUpButtonVisible: false,
            ),
          ),

          SizedBox(height: 10),

          // PixelSelectionGrid(
          //   heading: "Sounds good! Which Pixel model are you pitching?",
          //   items: [
          //     "Pixel 9",
          //     "Pixel 9 Pro",
          //     "Pixel 9 Pro XL",
          //     "Pixel 9 Pro XL",
          //     "Pixel 9 Pro Fold",
          //     "Pixel 8",
          //     "Pixel 8 Pro",
          //     "Pixel 8a",
          //     "Pixel 10",
          //     "Pixel 10 Pro",
          //     "Pixel 10 Pro XL",
          //     "Pixel 10 Pro Fold",
          //     "Pixel Buds Pro 2",
          //     "Pixel Watch 4",
          //     "Pixel Watch 4",
          //   ],
          //   onItemSelected: (value) {
          //     print(value);
          //   },
          // ),

          // ChatInputField(
          //   isActive: false,
          //   controller: _controller,
          //   onMicTap: () {},
          //   onSendTap: () {},
          // ),
        ],
      ),
    );
  }
}

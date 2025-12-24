import 'package:custom_widget/components/chat_input_field.dart';
import 'package:custom_widget/components/pixel_selection_grid.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        mainAxisAlignment: .center,
        children: [
          PixelSelectionGrid(
            heading: "Sounds good! Which Pixel model are you pitching?",
            items: [
              "Pixel 9",
              "Pixel 9 Pro",
              "Pixel 9 Pro XL",
              "Pixel 9 Pro XL",
              "Pixel 9 Pro Fold",
              "Pixel 8",
              "Pixel 8 Pro",
              "Pixel 8a",
              "Pixel 10",
              "Pixel 10 Pro",
              "Pixel 10 Pro XL",
              "Pixel 10 Pro Fold",
              "Pixel Buds Pro 2",
              "Pixel Watch 4",
              "Pixel Watch 4",
            ],
            onItemSelected: (value) {
              print(value);
            },
          ),

          ChatInputField(
            isActive: false,
            controller: _controller,
            onMicTap: () {},
            onSendTap: () {},
          ),
        ],
      ),
    );
  }
}

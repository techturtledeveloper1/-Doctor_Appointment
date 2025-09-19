import 'package:flutter/material.dart';
import '../../../Utils/ColorConstant.dart';

class ChatScreen extends StatelessWidget {
  final String doctorName;

  const ChatScreen({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat - $doctorName",style: TextStyle(color: ColorConstant.colorWhite)),
        backgroundColor: ColorConstant.colorIntroBG,
      ),
      body: Column(
        children: [
          /// Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10, // Example messages
              itemBuilder: (context, index) {
                return Align(
                  alignment: index % 2 == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? Colors.grey.shade300
                          : ColorConstant.colorIntroBG,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Message $index",
                      style: TextStyle(
                        color: index % 2 == 0 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// Input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: ColorConstant.colorIntroBG),
                  onPressed: () {
                    // TODO: send message logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

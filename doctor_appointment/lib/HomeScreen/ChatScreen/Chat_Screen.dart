import 'dart:convert';
import 'dart:io';

import 'package:doctor_appointment/HomeScreen/zego_services.dart'
    show ZegoService;
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_zim/zego_zim.dart';

class MyZegoHandler extends ZIMEventHandler {
  final Function(List<ZIMMessage>, String) onMessage;

  MyZegoHandler(this.onMessage);

  @override
  void onReceivePeerMessage(
    ZIM zim,
    List<ZIMMessage> messageList,
    String fromUserID,
  ) {
    onMessage(messageList, fromUserID);
  }
}

class ChatScreen extends StatefulWidget {
  final String myId;
  final String myName;
  final String peerId;
  final String peerName;

  const ChatScreen({
    super.key,
    required this.myId,
    required this.myName,
    required this.peerId,
    required this.peerName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool _isZegoReady = false;

  @override
  void initState() {
    super.initState();
    loadMessages();
    initZego();
  }

  void loadMessages() {
    final box = Hive.box('chatBox');
    final data = box.values.toList();

    setState(() {
      messages = data.map((e) {
        return {
          "text": e["text"],
          "image": e["image"],
          "imageUrl": e["imageUrl"],
          "isMe": e["isMe"],
          "time": DateTime.parse(e["time"]),
        };
      }).toList();
    });
  }

  /// 🔥 SAVE MESSAGE
  void saveMessage(Map<String, dynamic> msg) {
    final box = Hive.box('chatBox');

    box.add({
      "text": msg["text"],
      "image": msg["image"],
      "imageUrl": msg["imageUrl"],
      "isMe": msg["isMe"],
      "time": msg["time"].toString(),
    });
  }

  Future<void> initZego() async {
    ZegoService().init();
    await ZegoService().login(widget.myId, widget.myName);
    _isZegoReady = true;
    print("✅ Zego fully ready");
    ZIMEventHandler.onReceivePeerMessage =
        (ZIM zim, List<ZIMMessage> messageList, String fromUserID) {
          if (fromUserID != widget.peerId) return;

          setState(() {
            for (var msg in messageList) {
              if (msg is ZIMTextMessage) {
                messages.add({
                  "text": msg.message,
                  "image": null,
                  "imageBytes": null,
                  "isMe": false,
                  "time": DateTime.now(),
                });
              } else if (msg is ZIMImageMessage) {
                messages.add({
                  "text": null,
                  "image": msg.fileLocalPath,
                  "imageUrl": msg.fileDownloadUrl,
                  "isMe": false,
                  "time": DateTime.now(),
                });
              }
            }
          });

          scrollToBottom();
        };
  }

  void sendMessage() async {
    String text = controller.text.trim();
    if (text.isEmpty) return;

    await ZegoService().sendTextMessage(widget.peerId, text);

    // setState(() {
    //   messages.add({
    //     "text": text,
    //     "image": null,
    //     "isMe": true,
    //     "time": DateTime.now(),
    //   });
    // });
    final msg = {
      "text": text,
      "image": null,
      "imageUrl": null,
      "isMe": true,
      "time": DateTime.now(),
    };
    setState(() => messages.add(msg));
    saveMessage(msg);

    controller.clear();
    scrollToBottom();
  }

  Future<void> pickAndSendImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);
    List<int> imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    await ZegoService().sendImageMessage(widget.peerId, file.path);
    // setState(() {
    //   messages.add({
    //     "text": null,
    //     "image": file.path,
    //     "isMe": true,
    //     "time": DateTime.now(),
    //   });
    // });
    final msg = {
      "text": null,
      "image": file.path,
      "imageUrl": null,
      "isMe": true,
      "time": DateTime.now(),
    };

    setState(() => messages.add(msg));
    saveMessage(msg);

    scrollToBottom();
  }

  // void scrollToBottom() {
  //   Future.delayed(const Duration(milliseconds: 200), () {
  //     scrollController.animateTo(
  //       scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget messageBubble1(Map<String, dynamic> msg) {
    bool isMe = msg["isMe"];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColor.colorPrimary : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe
                ? const Radius.circular(12)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(12),
          ),
        ),
        child: Text(
          msg["text"],
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget messageBubble(Map<String, dynamic> msg) {
    bool isMe = msg["isMe"];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? AppColor.colorPrimary : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe
                ? const Radius.circular(12)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (msg["image"] != null && msg["image"].toString().isNotEmpty)
              Image.file(
                File(msg["image"]),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
            else if (msg["imageUrl"] != null &&
                msg["imageUrl"].toString().isNotEmpty)
              Image.network(
                msg["imageUrl"],
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),

            if (msg["text"] != null)
              Text(
                msg["text"],
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),

            const SizedBox(height: 5),

            Text(
              formatTime(msg["time"]),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatInput1() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Type message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget chatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.image, color: AppColor.colorPrimary),
            onPressed: pickAndSendImage,
          ),

          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Type message...",
                border: InputBorder.none,
              ),
            ),
          ),

          IconButton(
            icon: Icon(Icons.send, color: AppColor.colorPrimary),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }

  void clearChat() async {
    final box = Hive.box('chatBox');

    await box.clear();

    setState(() {
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(
          widget.peerName,
          style: TextStyle(fontSize: 20, color: AppColor.white),
        ),
        backgroundColor: AppColor.colorPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => showClearDialog(),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(top: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messageBubble(messages[index]);
              },
            ),
          ),

          chatInput(),
        ],
      ),
    );
  }

  void showClearDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Clear Chat"),
          content: Text("Are you sure you want to delete all messages?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                clearChat();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

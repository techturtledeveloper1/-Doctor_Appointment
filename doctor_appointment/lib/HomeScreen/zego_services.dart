import 'package:zego_zim/zego_zim.dart';

import 'package:zego_zim/zego_zim.dart';

class ZegoService {
  static final ZegoService _instance = ZegoService._internal();
  factory ZegoService() => _instance;
  ZegoService._internal();

  ZIM? _zim;
  bool _isInitialized = false;
  bool _isLoggedIn = false;

  Future<void> init() async {
    if (_isInitialized) {
      print("Zego already initialized");
      return;
    }

    try {
      print("🔧 Creating ZIM instance...");
      final appConfig = ZIMAppConfig(
        appID: 1334081427,
        appSign:
            "a34e019fe6a04ea93b51b588b3f628a1eb7ee348ed69aab76ab819dfbcf2badc",
      );

      _zim = await ZIM.create(appConfig);

      if (_zim == null) {
        throw Exception("Failed to create ZIM instance");
      }

      _isInitialized = true;
      print("✅ ZIM instance created successfully");
    } catch (e) {
      print("❌ Zego init failed: $e");
      rethrow;
    }
  }

  Future<void> login(String userId, String userName) async {
    if (_zim == null) {
      throw Exception("ZIM not initialized. Call init() first.");
    }

    if (_isLoggedIn) {
      print("Already logged in as: $userId");
      return;
    }

    try {
      print("🔐 Logging in: $userId / $userName");

      final config = ZIMLoginConfig()..userName = userName;

      await _zim!.login(userId, config);

      _isLoggedIn = true;
      print("✅ Login successful");
    } catch (e) {
      print("❌ Login failed: $e");
      _isLoggedIn = false;
      rethrow;
    }
  }

  Future<void> sendTextMessage(String peerId, String message) async {
    if (_zim == null) {
      throw Exception("ZIM not initialized");
    }

    // if (!_isLoggedIn) {
    //   throw Exception("User not logged in");
    // }

    try {
      await _zim!.sendMessage(
        ZIMTextMessage(message: message),
        peerId,
        ZIMConversationType.peer,
        ZIMMessageSendConfig(),
      );
    } catch (e) {
      print("❌ Send failed: $e");
      rethrow;
    }
  }

  Future<void> sendImageMessage(String peerId, String filePath) async {
    if (_zim == null) {
      throw Exception("ZIM not initialized");
    }

    if (!_isLoggedIn) {
      throw Exception("User not logged in");
    }

    try {
      await _zim!.sendMessage(
        ZIMImageMessage(filePath),
        peerId,
        ZIMConversationType.peer,
        ZIMMessageSendConfig(),
      );
    } catch (e) {
      print("❌ Send image failed: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    if (_zim != null && _isLoggedIn) {
      await _zim!.logout();
      _isLoggedIn = false;
      print("Logged out");
    }
  }
}
// import 'package:zego_zim/zego_zim.dart';

//
// class ZegoService {
//   static final ZegoService _instance = ZegoService._internal();
//   factory ZegoService() => _instance;
//
//   ZegoService._internal();
//
//   ZIM? _zim; // Make it nullable to check initialization state
//   bool _isLoggedIn = false;
//   Future<void> init() async {
//     try {
//       final appConfig = ZIMAppConfig(
//         appID: 1334081427,
//         appSign:
//             "a34e019fe6a04ea93b51b588b3f628a1eb7ee348ed69aab76ab819dfbcf2badc",
//       );
//
//       print("🔧 Initializing Zego SDK...");
//       _zim = await ZIM.create(appConfig);
//
//       if (_zim == null) {
//         throw Exception("Failed to create ZIM instance");
//       }
//
//       print("✅ Zego SDK initialized successfully");
//     } catch (e) {
//       print("❌ Zego init failed: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> login(String userId, String userName) async {
//     if (_zim == null) {
//       throw Exception("ZIM not initialized. Call init() first.");
//     }
//
//     try {
//       print("🔐 Logging in to Zego: userId=$userId, userName=$userName");
//
//       final config = ZIMLoginConfig()..userName = userName;
//
//       await _zim!.login(userId, config);
//       print("✅ Zego login successful for user: $userId");
//     } catch (e) {
//       print("❌ Zego login failed: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> sendTextMessage(String peerId, String message) async {
//     if (_zim == null) {
//       throw Exception("ZIM not initialized");
//     }
//
//     try {
//       print("📤 Sending text message to: $peerId");
//
//       await _zim!.sendMessage(
//         ZIMTextMessage(message: message),
//         peerId,
//         ZIMConversationType.peer,
//         ZIMMessageSendConfig(),
//       );
//
//       print("✅ Message sent successfully");
//     } catch (e) {
//       print("❌ Failed to send message: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> sendImageMessage(String peerId, String filePath) async {
//     if (_zim == null) {
//       throw Exception("ZIM not initialized");
//     }
//
//     try {
//       print("📤 Sending image message to: $peerId");
//
//       await _zim!.sendMessage(
//         ZIMImageMessage(filePath),
//         peerId,
//         ZIMConversationType.peer,
//         ZIMMessageSendConfig(),
//       );
//
//       print("✅ Image message sent successfully");
//     } catch (e) {
//       print("❌ Failed to send image: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> logout() async {
//     if (_zim != null) {
//       await _zim!.logout();
//       print("🔓 Logged out from Zego");
//     }
//   }
//
//   ZIM? get zim => _zim;
// }

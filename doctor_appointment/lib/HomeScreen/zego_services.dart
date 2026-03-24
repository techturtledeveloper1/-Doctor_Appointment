import 'package:zego_zim/zego_zim.dart';

class ZegoService {
  static final ZegoService _instance = ZegoService._internal();
  factory ZegoService() => _instance;

  ZegoService._internal();

  late ZIM zim;

  void init() {
    ZIMAppConfig config = ZIMAppConfig();
    config.appID = 1334081427;
    config.appSign =
        "a34e019fe6a04ea93b51b588b3f628a1eb7ee348ed69aab76ab819dfbcf2badc";

    zim = ZIM.create(config)!;
  }

  Future<void> login(String userId, String userName) async {
    await zim.login(userId, ZIMLoginConfig()..userName = userName);
  }

  Future<void> sendTextMessage(String peerId, String message) async {
    await zim.sendMessage(
      ZIMTextMessage(message: message),
      peerId,
      ZIMConversationType.peer,
      ZIMMessageSendConfig(),
    );
  }

  Future<void> sendImageMessage(String peerId, String filePath) async {
    await zim.sendMessage(
      ZIMImageMessage(filePath),
      peerId,
      ZIMConversationType.peer,
      ZIMMessageSendConfig(),
    );
  }

  Future<void> logout() async {
    await zim.logout();
  }
}

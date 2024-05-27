import 'package:flutter/widgets.dart';
import 'package:quickchat/modules/auth/utils/auth_service.dart';
import 'package:quickchat/utils.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  CallPage({super.key, required this.callID});

  final String callID;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final userId = _authService.getCurrentUser()!.uid;
    final userName = _authService.getCurrentUser()!.displayName;

    return ZegoUIKitPrebuiltCall(
      appID: appId,
      appSign: appSign,
      userID: userId,
      userName: userName!,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}

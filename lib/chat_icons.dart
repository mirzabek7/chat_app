// Place fonts/chat.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: chat
//      fonts:
//       - asset: fonts/chat.ttf
import 'package:flutter/widgets.dart';

class Chat {
  Chat._();

  static const String _fontFamily = 'chat';

  static const IconData btn = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData Audio = IconData(0xe901, fontFamily: _fontFamily);
  static const IconData Attach = IconData(0xe902, fontFamily: _fontFamily);
  static const IconData Search_s = IconData(0xe903, fontFamily: _fontFamily);
}

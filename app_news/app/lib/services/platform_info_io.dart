import 'dart:io';

String getBaseUrl() {
  // On Android emulator use the special host to reach host machine.
  if (Platform.isAndroid) return 'http://10.0.2.2:3000';

  // For desktop (Windows/macOS/Linux) and iOS simulator, localhost works.
  return 'http://localhost:3000';
}

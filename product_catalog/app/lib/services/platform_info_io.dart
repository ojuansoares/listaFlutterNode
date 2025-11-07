import 'dart:io';

String getBaseUrl() {
  if (Platform.isAndroid) return 'http://10.0.2.2:3001';
  return 'http://localhost:3001';
}

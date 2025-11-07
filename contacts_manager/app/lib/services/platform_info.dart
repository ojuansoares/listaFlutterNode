// Conditional export: use IO implementation for native, web implementation for web
export 'platform_info_io.dart' if (dart.library.html) 'platform_info_web.dart';

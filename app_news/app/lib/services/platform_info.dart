// Conditional export: use the IO implementation when compiling to native
// and the web implementation when compiling to web (dart:html).
export 'platform_info_io.dart' if (dart.library.html) 'platform_info_web.dart';

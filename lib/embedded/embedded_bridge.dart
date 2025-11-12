export 'embedded_bridge_interface.dart';

import 'embedded_bridge_interface.dart';
import 'embedded_bridge_stub.dart'
    if (dart.library.html) 'embedded_bridge_web.dart';

/// Singleton instance that mediates communication with the vendor portal
/// when the Flutter app runs inside the embedded iframe.
final EmbeddedBridge embeddedBridge = createEmbeddedBridge();

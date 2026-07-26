/// Abstract class contract for Network Information check
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Simple implementation for checking connectivity state
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // Basic connectivity check placeholder (Offline-First support)
    return true;
  }
}

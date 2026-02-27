import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure wrapper around FlutterSecureStorage for API key management.
///
/// On Windows this uses the Windows Credential Manager, which means keys
/// are never written to plain-text files on disk.
class SecureStorageDataSource {
  SecureStorageDataSource([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyPrefix = 'api_key_';

  /// Writes an API key for the given provider config ID.
  Future<void> writeApiKey(String configId, String key) async {
    await _storage.write(key: '$_keyPrefix$configId', value: key);
  }

  /// Reads the API key for the given provider config ID.
  /// Returns `null` if no key has been stored.
  Future<String?> readApiKey(String configId) async {
    return _storage.read(key: '$_keyPrefix$configId');
  }

  /// Deletes the stored API key for the given provider config ID.
  Future<void> deleteApiKey(String configId) async {
    await _storage.delete(key: '$_keyPrefix$configId');
  }

  /// Returns a map of all stored API keys keyed by config ID.
  Future<Map<String, String>> readAllApiKeys() async {
    final all = await _storage.readAll();
    final result = <String, String>{};
    for (final entry in all.entries) {
      if (entry.key.startsWith(_keyPrefix)) {
        final configId = entry.key.substring(_keyPrefix.length);
        result[configId] = entry.value;
      }
    }
    return result;
  }
}

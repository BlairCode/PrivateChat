import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service class for handling encryption and decryption of messages.
class CryptoService {
  final _storage = const FlutterSecureStorage();
  static const String _keyName = 'encryption_key';

  /// Retrieves or generates a secure encryption key.
  Future<Key> _getKey() async {
    final String? keyString = await _storage.read(key: _keyName);
    if (keyString == null) {
      final newKey = Key.fromSecureRandom(32); // 32-byte AES key
      await _storage.write(key: _keyName, value: newKey.base64);
      return newKey;
    }
    return Key.fromBase64(keyString); // Fixed typo
  }

  /// Encrypts the plaintext and returns the encrypted data with IV prepended.
  Future<String> encrypt(String plainText) async {
    try {
      final key = await _getKey();
      final iv = IV.fromSecureRandom(16); // New IV for each encryption
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      // Prepend IV to the encrypted data (IV + ciphertext)
      final ivAndCiphertext = '${iv.base64}:${encrypted.base64}';
      return ivAndCiphertext;
    } catch (e) {
      print(
        'Encryption failed: $e',
      ); // Replace with proper logging in production
      throw Exception('Encryption error: $e');
    }
  }

  /// Decrypts the encrypted text (IV:ciphertext format).
  Future<String> decrypt(String encryptedText) async {
    try {
      final parts = encryptedText.split(':');
      if (parts.length != 2) {
        throw Exception('Invalid encrypted format');
      }
      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      final key = await _getKey();
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      print(
        'Decryption failed: $e',
      ); // Replace with proper logging in production
      throw Exception('Decryption error: $e');
    }
  }
}

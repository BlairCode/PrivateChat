import 'package:http/http.dart' as http;
import 'package:private_chat/services/crypto_service.dart';

/// Service class for handling network communication with the server.
class NetworkService {
  final CryptoService _cryptoService = CryptoService();
  final String _baseUrl;

  /// Constructs the service with an optional base URL.
  NetworkService({
    String baseUrl = 'https://18b1-222-185-29-175.ngrok-free.app',
  }) : _baseUrl = baseUrl;

  /// Sends an encrypted message to the server and returns the response.
  Future<String> sendMessage(String message) async {
    try {
      // Encrypt the message (returns IV:ciphertext format)
      final encryptedMessage = await _cryptoService.encrypt(message);

      final response = await http
          .post(
            Uri.parse('$_baseUrl/message'),
            body: encryptedMessage,
            headers: {'Content-Type': 'text/plain'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Optionally decrypt response.body if server sends encrypted data
        return 'Message sent: ${response.body}';
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e'); // Replace with proper logging in production
      rethrow; // Propagate the error for caller to handle
    }
  }
}

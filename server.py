from http.server import HTTPServer, BaseHTTPRequestHandler
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
import base64
import logging

# Configure logging for better debugging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class MessageHandler(BaseHTTPRequestHandler):
    """HTTP request handler for receiving and processing encrypted messages."""

    # Hardcoded key (should be securely configured/stored in production, e.g., environment variables)
    KEY = b'my32lengthsupersecretkey12345678'  # 32 bytes, must match client

    def _decrypt_message(self, encrypted_text):
        """Decrypts an AES-CBC encrypted message in 'IV:ciphertext' format."""
        try:
            # Split IV and ciphertext
            iv_str, ciphertext_str = encrypted_text.split(':')
            iv = base64.b64decode(iv_str)
            encrypted_bytes = base64.b64decode(ciphertext_str)
            
            # Ensure IV is 16 bytes
            if len(iv) != 16:
                raise ValueError("Invalid IV length")
            
            cipher = Cipher(algorithms.AES(self.KEY), modes.CBC(iv), backend=default_backend())
            decryptor = cipher.decryptor()
            padded_data = decryptor.update(encrypted_bytes) + decryptor.finalize()
            # Remove PKCS7 padding
            padding_len = padded_data[-1]
            return padded_data[:-padding_len].decode('utf-8')
        except Exception as e:
            logger.error(f"Decryption failed: {e}")
            raise

    def do_POST(self):
        """Handles POST requests to '/message' endpoint."""
        try:
            if self.path != '/message':
                self.send_response(404)
                self.end_headers()
                return

            content_length = int(self.headers.get('Content-Length', 0))
            if content_length <= 0:
                self.send_response(400)
                self.end_headers()
                self.wfile.write(b"Bad request: No data")
                return

            encrypted_data = self.rfile.read(content_length).decode('utf-8')
            decrypted_message = self._decrypt_message(encrypted_data)
            logger.info(f"Received message: {decrypted_message}")

            self.send_response(200)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(b"Message received")
        except Exception as e:
            logger.error(f"Error processing request: {e}")
            self.send_response(500)
            self.end_headers()
            self.wfile.write(b"Server error")

def run_server(host='0.0.0.0', port=8080):
    """Starts the HTTP server on the specified host and port."""
    server_address = (host, port)
    httpd = HTTPServer(server_address, MessageHandler)
    logger.info(f"Server running on {host}:{port}...")
    httpd.serve_forever()

if __name__ == '__main__':
    run_server()
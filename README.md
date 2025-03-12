Private Chat（Developing）

![Private Chat Logo](https://via.placeholder.com/150.png?text=Private+Chat)  
*A secure, simple, and private messaging app built with Flutter.*

## Overview

Private Chat is a Flutter-based mobile application designed for secure, end-to-end encrypted messaging. It stores messages locally using SQLite and cleans up old messages automatically with a background task. Perfect for personal use or as a starting point for your own chat app!

## Features

- **End-to-End Encryption**: Messages are encrypted with AES-CBC using a secure key stored in `flutter_secure_storage`.
- **Local Storage**: Messages are saved in SQLite via `sqflite` for offline access.
- **Automatic Cleanup**: Uses `workmanager` to schedule daily message deletion.
- **Simple UI**: A clean, pink-themed Material Design interface.
- **Cross-Platform**: Works on Android and iOS (with minor setup tweaks).

## Screenshots

| Chat Screen | Encrypted Message |
|-------------|-------------------|
| ![Chat Screen](https://via.placeholder.com/300x600.png?text=Chat+Screen) | ![Encrypted](https://via.placeholder.com/300x600.png?text=Encrypted+Message) |

## Getting Started

### Prerequisites

- **Flutter**: SDK version >= 3.0.0 < 4.0.0 (tested with 3.7.0)
- **Python**: 3.x for the server (with `cryptography` library)
- **Android/iOS Device or Emulator**: For running the app

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/private_chat.git
   cd private_chat
   ```

2. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

3. **Install Python Dependencies (for server)**
   ```bash
   pip install cryptography
   ```

4. **Run the Server**
   - Open a terminal in the project directory:
     ```bash
     python server.py
     ```
   - Server will run on `0.0.0.0:8080` by default.

5. **Run the App**
   - Ensure a device/emulator is connected:
     ```bash
     flutter run --debug
     ```

### Configuration

- **Server URL**: Edit `network_service.dart` to change the default URL (`https://your-server-url`).
- **Encryption Key**: The app generates a key automatically, stored securely. Ensure the server key matches (currently hardcoded in `server.py`).

## Usage

1. Open the app on your device.
2. Type a message in the text field and press the send button.
3. Messages are encrypted, sent to the server, and stored locally.
4. Old messages are cleaned up daily by a background task.

## Project Structure

```
private_chat/
├── lib/
│   ├── main.dart              # App entry point
│   ├── services/             # Network, database, and crypto services
│   ├── widgets/             # UI components (e.g., ChatScreen)
│   └── utils/               # Utilities (e.g., cleanup)
├── server.py                # Python server for receiving messages
└── pubspec.yaml            # Flutter dependencies
```

## Contributing

We welcome contributions! Here's how to get involved:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m "Add your feature"`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

## Known Issues

- `workmanager` 0.5.2 may need local patching for Flutter 3.7.0 (see troubleshooting).
- Server uses a hardcoded key (improve with environment variables in production).

## Troubleshooting

- **Workmanager Compilation Error**: If using Flutter 3.7.0+, patch `workmanager` locally:
  - Edit files in `C:/Users/yourusername/AppData/Local/Pub/Cache/hosted/pub.dev/workmanager-0.5.2/android/src/main/kotlin/`.
  - Or use a local path in `pubspec.yaml`: `path: ../flutter_workmanager-main/workmanager`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with love by [yourusername] with help from Grok 3 (xAI).
- Thanks to the Flutter community for awesome packages!

---
*Happy chatting! Let’s keep our secrets safe.* 💕

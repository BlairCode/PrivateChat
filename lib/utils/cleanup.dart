import 'package:workmanager/workmanager.dart';
import 'package:private_chat/services/db_service.dart';

/// Dispatcher for background tasks registered with Workmanager.
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "deleteMessages":
        try {
          final dbService = DatabaseService();
          await dbService.deleteAllMessages();
          print(
            "Cleanup task completed: All messages deleted",
          ); // Replace with proper logging in production
          return Future.value(true);
        } catch (e) {
          print(
            "Cleanup task failed: $e",
          ); // Replace with proper logging in production
          return Future.value(false);
        }
      default:
        print("Unknown task: $task");
        return Future.value(false);
    }
  });
}

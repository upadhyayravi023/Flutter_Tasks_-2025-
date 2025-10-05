import 'package:shared_preferences/shared_preferences.dart';
import '../../model/reminder_model.dart';

class ReminderRepository {
  static const String _remindersKey = 'reminders';


  Future<List<Reminder>> getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? remindersJson = prefs.getStringList(_remindersKey);

    if (remindersJson == null) {
      return [];
    }

    return remindersJson.map((json) => Reminder.fromJson(json)).toList();
  }


  Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();


    final List<String> remindersJson = reminders.map((reminder) => reminder.toJson()).toList();

    await prefs.setStringList(_remindersKey, remindersJson);
  }
}

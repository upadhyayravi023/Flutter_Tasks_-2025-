import 'package:flutter/material.dart';
import '../data/local_storage/reminder_repository.dart';
import '../model/reminder_model.dart';
import 'package:uuid/uuid.dart';

class ReminderViewModel extends ChangeNotifier {
  final ReminderRepository _repository = ReminderRepository();
  List<Reminder> _reminders = [];
  bool _isLoading = false;

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;


  final _uuid = const Uuid();

  ReminderViewModel() {
    loadReminders();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }


  Future<void> loadReminders() async {
    _setLoading(true);
    _reminders = await _repository.getReminders();
    _setLoading(false);
  }

  // Add a new reminder
  Future<void> addReminder(String title) async {
    final newReminder = Reminder(id: _uuid.v4(), title: title);
    _reminders.add(newReminder);
    await _repository.saveReminders(_reminders);
    notifyListeners();
  }


  Future<void> toggleReminderStatus(String id) async {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index].isCompleted = !_reminders[index].isCompleted;
      await _repository.saveReminders(_reminders);
      notifyListeners();
    }
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    await _repository.saveReminders(_reminders);
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rudraksha_task_3/utils/routes/routes_name.dart';
import 'package:rudraksha_task_3/view_model/auth_view_model.dart';
import 'package:rudraksha_task_3/view_model/theme_view_model.dart';
import '../res/colors.dart';
import '../view_model/reminder_view_model.dart';
import '../model/reminder_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _reminderController = TextEditingController();

  void _showAddReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('New Reminder'),
          content: TextField(
            controller: _reminderController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g., Buy Groceries'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _reminderController.clear();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_reminderController.text.isNotEmpty) {
                  context.read<ReminderViewModel>().addReminder(_reminderController.text);
                  Navigator.of(context).pop();
                  _reminderController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the user email once using context.read for efficiency.
    final userEmail = context.read<AuthViewModel>().user?.email ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundImage: NetworkImage('https://www.shareicon.net/data/2016/05/24/770136_man_512x512.png'),
            ),
            onSelected: (value) {
              final authViewModel = context.read<AuthViewModel>();
              final themeViewModel = context.read<ThemeViewModel>();

              switch (value) {
                case 'logout':
                  authViewModel.signOut().then((_) {
                    // Using rootNavigator: true helps avoid context issues after async gaps.
                    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                      RoutesName.login,
                          (route) => false,
                    );
                  });
                  break;
                case 'light':
                  themeViewModel.setTheme(ThemeMode.light);
                  break;
                case 'dark':
                  themeViewModel.setTheme(ThemeMode.dark);
                  break;
                case 'system':
                  themeViewModel.setTheme(ThemeMode.system);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'email',
                enabled: false,
                child: Text(
                  userEmail,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'theme',
                enabled: false,
                child: Text("Change Theme", style: TextStyle(color: Colors.grey)),
              ),
              PopupMenuItem<String>(
                value: 'light',
                child: Row(children: [Icon(Icons.light_mode), SizedBox(width: 8), Text('Light')]),
              ),
              PopupMenuItem<String>(
                value: 'dark',
                child: Row(children: [Icon(Icons.dark_mode), SizedBox(width: 8), Text('Dark')]),
              ),
              PopupMenuItem<String>(
                value: 'system',
                child: Row(children: [Icon(Icons.brightness_auto), SizedBox(width: 8), Text('System')]),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Log Out'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<ReminderViewModel>(
          builder: (context, reminderViewModel, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Hi ${userEmail}!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Here are your set reminders',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: reminderViewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      itemCount: reminderViewModel.reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminderViewModel.reminders[index];
                        return _buildReminderCard(context, reminder, index);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context, Reminder reminder, int index) {
    return Dismissible(
      key: Key(reminder.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<ReminderViewModel>().deleteReminder(reminder.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${reminder.title} deleted')),
        );
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: AppColors.getColorForIndex(index),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            reminder.title,
            style: TextStyle(
              fontSize: 18,
              color: ThemeData.estimateBrightnessForColor(AppColors.getColorForIndex(index)) == Brightness.dark
                  ? Colors.white : Colors.black,
              decoration: reminder.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: Checkbox(
            value: reminder.isCompleted,
            onChanged: (bool? value) {
              context.read<ReminderViewModel>().toggleReminderStatus(reminder.id);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ),
    );
  }
}
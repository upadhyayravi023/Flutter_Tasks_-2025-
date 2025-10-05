-----

# Flutter Reminder App

A simple yet powerful reminder and to-do list application built with Flutter. This app allows users to manage their daily tasks with a clean, intuitive interface, featuring user authentication, local data persistence, and a dynamic theme system.

## Overview & Features

This project is a complete mobile application that demonstrates best practices in Flutter development, including state management, architectural patterns, and local data storage.

* **Firebase Authentication:** Secure user sign-up and login using email and password.
* **Task Management:** Users can add new reminders, mark them as complete, and delete them with a simple swipe.
* **Local Persistence:** Reminders and user preferences are saved locally on the device using `shared_preferences`, ensuring data is available even after the app is closed.
* **Theme Switching:** Users can choose between Light Mode, Dark Mode, or the System Default theme.
* **MVVM Architecture:** The codebase is structured using the robust Model-View-ViewModel pattern for scalability and maintainability.

-----

## Demo & APK

You can see the app in action or install it directly on your Android device using the links below.

* **[Watch Usage Video](https://drive.google.com/drive/folders/1btXJf8pnUB8-yNHk4rlGBqpqavJzp6iu?usp=sharing)**
* **[Download APK File](https://drive.google.com/drive/folders/1btXJf8pnUB8-yNHk4rlGBqpqavJzp6iu?usp=sharing)**

*(Note: Both links point to the same Google Drive folder. You may need to enable installation from unknown sources on your Android device to install the APK.)*

-----

## Approach and Tools Used

The application is built with a focus on creating a clean, scalable, and testable codebase.

### **MVVM (Model-View-ViewModel) Architecture**

MVVM is the core architectural pattern used in this project to separate the user interface (View) from the business logic (ViewModel) and the data (Model).

* **Model:** Represents the application's data structure (`Reminder.dart`). It's a plain Dart class with no knowledge of business logic.
* **View:** The UI of the application (`home_view.dart`, `login_view.dart`). It only displays data from the ViewModel and forwards user actions to it.
* **ViewModel:** The brain of the application (`reminder_view_model.dart`, `auth_view_model.dart`). It holds the application's state and business logic, updating the View when the state changes.

### **Key Tools & Packages**

* **Flutter & Dart:** For building the cross-platform mobile application.
* **Provider:** A powerful state management solution used to implement the connection between the Views and ViewModels.
* **Firebase Auth:** For handling all user authentication processes.
* **SharedPreferences:** For simple, local key-value storage to persist the reminder list and theme settings.

-----

## Getting Started: How to Run the Project

To get a local copy up and running, follow these simple steps.

### **Prerequisites**

* Flutter SDK installed on your machine.
* A code editor like VS Code or Android Studio with the Flutter plugin.
* A configured emulator or a physical device.

### **Installation & Setup**

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/your-repository-name.git
    ```
2.  **Set Up Firebase:**
    * Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    * Register your app (for Android and/or iOS).
    * In the **Authentication** section, go to the "Sign-in method" tab and **enable Email/Password** authentication.
    * Follow the setup instructions to download the `google-services.json` file (for Android) and/or the `GoogleService-Info.plist` file (for iOS). Place them in the correct directories as instructed by Firebase.
3.  **Install Dependencies:**
    Navigate to the project directory and run:
    ```sh
    flutter pub get
    ```
4.  **Run the App:**
    ```sh
    flutter run
    ```

-----

## Challenges Faced & Solutions

### **1. Managing Code Complexity with MVVM**

* **Challenge:** The MVVM architecture, by design, splits logic across many different files. Initially, tracing the flow of data—from a user tap in the View, to a method call in the ViewModel, to a data operation in the Repository—was challenging.
* **Solution:** The initial complexity of MVVM quickly revealed its strength: **organization and scalability**. By strictly separating concerns, the code became incredibly modular. When a UI element looked wrong, I knew the problem was in a **View** file. When a reminder wasn't saving correctly, the issue had to be in the **ReminderRepository**. This isolation made it much faster to find and fix bugs.

### **2. Implementing Persistent Dark Mode**

* **Challenge:** The logic for theme switching required the app to (1) update the entire UI instantly when a theme was chosen, and (2) remember that choice the next time the app was opened. A common pitfall was having the UI not react immediately.
* **Solution:** The MVVM pattern provided a clear path:
    1.  **Repository (`ThemeRepository`):** A dedicated class was created to save and load the `ThemeMode` to `SharedPreferences`.
    2.  **ViewModel (`ThemeViewModel`):** This class holds the current `ThemeMode` as its state. It uses the repository to load the preference on startup and saves any new choice, then calls `notifyListeners()`.
    3.  **The "Aha\!" Moment (View):** The final piece was wrapping the `MaterialApp` widget in `main.dart` with a `Consumer<ThemeViewModel>`. This forces the very root of the application to listen for `notifyListeners()`. When the theme state changes, the `MaterialApp` rebuilds itself, applying the new `themeMode` globally and causing every screen to update instantly.
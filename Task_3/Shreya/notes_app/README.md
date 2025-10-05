# Flutter Notes App

A simple, clean, and modern note-taking application built with Flutter and Firebase. This app allows users to create accounts, log in, and manage their personal notes securely. The notes are saved in real-time and are available across sessions as long as the user is logged in.
The app features a minimalist UI with both light and dark mode themes.

## Features

1. Firebase Authentication: Secure user sign-up and login.
2. Cloud Firestore Integration: Notes are saved securely online and are tied to the user's account. Data persists across app restarts.
3. Real-time Updates: The note list updates instantly as new notes are created.
4. Dynamic Theming: Switch between a clean light mode and a sleek dark mode.
5. Error Handling: Displays user-friendly error messages for network issues or failed operations.

## Packages used

1. firebase_core: to initialize the FlutterFire SDK and connect the app to the Firebase project.
2. firebase_auth: to handle all user authentication, including creating user accounts and signing them in with email and password.
3. cloud_firestore: to interact with the Cloud Firestore NoSQL database, enabling the app to save, fetch, and listen for real-time updates to user notes.
4. provider: A state management library used in this project to manage the app's theme, allowing users to switch between light and dark modes dynamically.
5. fluttertoast: A simple utility for showing non-intrusive "toast" notifications. It's used to display user-friendly error messages and other feedback.

## Improvements

1. Edit Notes: Implement functionality to allow users to tap on an existing note to open it in the editor.
2. Delete Notes: Add a delete option, perhaps using a long-press gesture or a button within the note editor, to remove notes from Firestore.
3. Bookmarking Notes: Implementation of functionality to bookmark notes and view all the bookmarked notes at one place.

## App Demo and apk

[open folder](https://drive.google.com/drive/folders/10DwcIItSMYwdCfFDynBDlmgkYTctTqOr?usp=sharing)

# chat_app

A new Flutter project for Team Nougat (Task 2).

## About this app

This is a chat bot app powered with the help of Gemini AI. It was made possible using flutter_gemini package.

Its a simple app designed to answer short queries and describe a picture with the help of Gemini.

This app was made for purpose of learning about how to integrate AI in a flutter app.

## How to clone this project

1. In your terminal, clone the project.
   ```bash
   git clone repo_url
   ```
2. Reach chat_app directory.
   ```bash
   cd chat_app
   ```
3. Make a const.dart file in the lib folder of this repository.
   <pre>
   chat_app/ 
   |---lib/ 
   |   |---consts.dart \\make this file
   |   |---main.dart
   |   |---home_page.dart
   |---other folders
    </pre>
   
4. Get your own gemini api key and store it in consts.dart file.
   ```bash
   String GEMINI_API_KEY = "your_gemini_api_key"
   ```
5. Get the dependencies.
   ```bash
   flutter pub get
   ```
6. Run the project.
   ```bash
   flutter run
   ```

## Screenshots

### A simple Hi message
<img src="screen1.png" height="700" width="350"/>

### Describing a picture
<img src="screen2.png" height="700" width="350"/>

### Detailed query and streaming responses
<img src="screen3.png" height="700" width="350"/>



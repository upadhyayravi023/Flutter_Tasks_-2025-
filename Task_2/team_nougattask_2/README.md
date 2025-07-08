# team_nougattask_2

---

# 🌟 Flutter Gemini Chatbot App

## 📽️ Demo Video & Screenshots

> 📸 Demo video and screenshots available:  
[🔗 Google Drive Link](https://drive.google.com/drive/folders/1gUhvnY4U_gNREAs5YNvWdmAwZwtDRub7?usp=sharing)

---

## 📱 Overview

The **Flutter Gemini Chatbot App** is an AI-powered mobile application that enables users to engage in intelligent conversations using **Google's Gemini model**. Built with Flutter, this app integrates features like natural chat interaction, research assistance, and image analysis capabilities through Gemini's multimodal understanding.

---

## ✨ Features

- 💬 **AI Chat with Gemini**  
  Converse with Google's Gemini using text input and receive contextually intelligent replies.

- 🔍 **Research Assistant**  
  Query Gemini for deep-dive information or insights on a variety of topics using real-time prompts.

- 🖼️ **Image Upload & Analysis**  
  Send images and get descriptive or analytical responses using Gemini’s multimodal capabilities.

- 🔄 **Streaming Conversations**  
  Smooth, real-time streaming of Gemini's generated responses for a better UX.

---

## 🛠️ Technologies Used

- **Flutter** – For cross-platform app development.
- **Android Studio** – Development IDE and emulator testing.
- **Google Generative AI Package** – Official SDK to access Gemini models.
- **In-built Gemini Models** – Text and multimodal models for natural conversations and image analysis.
- **YouTube Developer Tutorials** – To understand Gemini APIs and Flutter integrations.

---

## ⚠️ Challenges Faced

### 1. `streamGenerate Content` Degeneration
While using `streamGenerate`, Android Studio termed the method as degenerate. This was mitigated by:

- Using `promptParts` and `generateContent()` instead of stream-based generation.
- Implementing custom stream listeners and managing token flow.

### 2. `DataPart` is not a subtype of type `Part`
This occurred during image upload using Gemini's multimodal input. It was resolved by:

- Replacing manual `DataPart` instances with `Part.fromBytes()` and appropriate MIME type.
- Ensuring compatibility with the latest `google_generative_ai` package version.

---


## 📌 Future Improvements

- 🔐 User authentication & chat history storage
- 🎙️ Voice-to-text input for faster interaction
- 🛡️ Enhanced error handling for Gemini API edge cases
- 📲 iOS support and build compatibility

---

## 📧 Contact

Feel free to reach out for questions or suggestions:  
**Rudraksha Kumar** – [rudrakshkumar11@gmail.com](mailto:rudrakshkumar11@gmail.com)

---

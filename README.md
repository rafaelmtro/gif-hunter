# 🎯 Gif Hunter v2.0.0

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-60B5CC?style=for-the-badge&logo=dart&logoColor=white)](https://riverpod.dev)
[![Giphy API](https://img.shields.io/badge/Giphy%20API-000000?style=for-the-badge&logo=giphy&logoColor=white)](https://developers.giphy.com/)

**Gif Hunter** is a high-performance, minimalist web application built with Flutter for searching, viewing, and sharing animated GIFs. Focused on speed and a frictionless user experience, it leverages the Giphy API to deliver instant results with a modern, responsive interface.

---

## ✨ Features

### 🔍 Powerful Search
- **Search-as-you-type:** Fluid, debounced search (500ms) for instantaneous results.
- **Trending Tags:** Browse and multi-select trending terms to discover new content.
- **Infinite Scroll:** Smart pre-fetching with duplicate filtering for an endless browsing experience.

### 💖 Personalization & Sharing
- **Favorites Gallery:** Save your favorite GIFs locally (`shared_preferences`) for quick access.
- **One-Tap Copy:** Quick-access "Copy Link" with visual "Copied!" feedback.
- **Social Integration:** Share directly to Telegram, Facebook, and WhatsApp.

### 🎨 Premium UI/UX
- **Modern Minimalist Design:** Sleek Orange & Black theme with rounded, fluid shapes.
- **Hero Animations:** Smooth transitions from grid items to full-screen detail views.
- **Animated Feedback:** Scale-down effects for unhearting and smooth hover states across the UI.
- **Responsive Layout:** Adaptive design that feels native on both Desktop and Mobile.
- **Skeleton Loading:** Shimmer effects for a polished "content is loading" experience.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable channel)
- A [Giphy API Key](https://developers.giphy.com/dashboard/)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rafaelmtro/gif-hunter.git
   cd gif-hunter
   ```

2. **Setup Environment:**
   Create a `.env` file in the root directory and add your Giphy API Key:
   ```env
   GIPHY_API_KEY=your_api_key_here
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the Application:**
   ```bash
   flutter run -d chrome
   ```

---

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev) (Web)
- **State Management:** [Riverpod](https://riverpod.dev)
- **Networking:** [Dio](https://pub.dev/packages/dio)
- **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)
- **Animations:** Custom Flutter Animations & [Hero](https://docs.flutter.dev/development/ui/animations/hero-animations) widgets.

---

## 🐳 Docker Support

For a consistent development environment, you can use the provided Docker configuration:

```bash
# Build the image
docker build -t gif-hunter-dev .

# Run the container
docker run -p 8080:8080 -v $(pwd):/app -it gif-hunter-dev
```

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

## 👤 Author

**Rafael Monteiro**
- GitHub: [@rafaelmtro](https://github.com/rafaelmtro)

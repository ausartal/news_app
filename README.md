<div align="center">

# News App Modern

**Production-ready Flutter news client powered by NewsAPI.org**

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/State-Riverpod-5B8DEF?style=for-the-badge)
![Dio](https://img.shields.io/badge/HTTP-Dio-0F7B6C?style=for-the-badge)
![NewsAPI](https://img.shields.io/badge/API-NewsAPI.org-FF6B35?style=for-the-badge)

![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue)

</div>

---

## Overview

News App Modern is a clean-architecture Flutter application that fetches live headlines from [NewsAPI.org](https://newsapi.org). It ships with a modern card-based feed, offline caching, bookmarks, dark mode, debounced search, category filtering, pull-to-refresh, and infinite scroll pagination.

## Features

- Live news feed via **NewsAPI.org** with Dio HTTP client
- Modern card-based UI with Hero animations on article detail
- Debounced search
- Category filtering chips
- Bookmarks stored locally with SharedPreferences
- Dark mode / light mode toggle
- Offline cache fallback when the network is unavailable
- Pull-to-refresh and infinite scroll pagination
- Clean architecture: `core` / `data` / `domain` / `presentation`

## Screenshots

> Screenshots are not yet available. Run the app locally to explore the UI.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x
- Dart SDK `>=3.3.0 <4.0.0`

### Install & Run

```bash
git clone https://github.com/ausartal/news_app.git
cd news_app

flutter pub get
flutter run
```

### API Key

A default NewsAPI key is bundled for convenience. To override it at run time:

```bash
flutter run --dart-define=NEWS_API_KEY=YOUR_NEWSAPI_KEY
```

If you use VS Code, add the same `--dart-define` to your launch configuration.

### Tests

```bash
flutter test
```

## Project Structure

```
news_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/app_constants.dart
│   │   ├── errors/app_exceptions.dart
│   │   ├── theme/app_theme.dart
│   │   └── utils/            # date formatter, debouncer, network checker
│   ├── data/
│   │   ├── models/           # article, news_response
│   │   ├── repositories/     # news & bookmarks repository impls
│   │   └── services/         # news_api_service, local_storage_service
│   ├── domain/
│   │   └── repositories/     # repository contracts
│   └── presentation/
│       ├── pages/            # home, detail, bookmarks, settings
│       ├── state/            # controllers & state classes
│       └── widgets/          # news_card, shimmer, chips, etc.
├── test/
│   └── widget_test.dart
├── android/ ios/ web/ linux/ macos/ windows/
└── pubspec.yaml
```

## Tech Stack

| Layer          | Choice                              |
| -------------- | ----------------------------------- |
| Framework      | Flutter / Dart                      |
| State          | flutter_riverpod                    |
| Networking     | dio                                 |
| Images         | cached_network_image                |
| Persistence    | shared_preferences                  |
| Connectivity   | connectivity_plus                   |
| Formatting     | intl                                |

## Author

**Ahmad Nabah Falah** — [@ausartal](https://github.com/ausartal)

## License

This project is available for educational and personal use.

# News App Modern

Production-ready Flutter news app using NewsAPI.org, Riverpod, Dio, cached images, offline cache, bookmarks, dark mode, debounce search, categories, pull to refresh, and infinite scroll.

## Folder Structure

- lib/core/ – constants, exceptions, theme, and utilities
- lib/data/ – models, API service, local storage, repositories
- lib/domain/ – repository contracts and shared result types
- lib/presentation/ – pages, widgets, and state management

## Setup API Key

API key sudah dipasang langsung di aplikasi.

Jika ingin override key saat run:

```bash
flutter run --dart-define=NEWS_API_KEY=YOUR_NEWSAPI_KEY
```

If you use VS Code, add the same dart-define to your launch configuration.

## Run the App

```bash
flutter pub get
flutter run
```

## Main Features

- API fetch with Dio
- Modern card-based news feed
- Article detail page with Hero animation
- Search with debounce
- Category filtering
- Bookmark storage with SharedPreferences
- Dark mode / light mode toggle
- Offline cache fallback
- Pull to refresh
- Infinite scroll pagination

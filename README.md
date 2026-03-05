##  Features

-  **Dark & Light Themes** - Beautiful Material 3 design
-  **Multilingual** - English & Arabic with RTL support
-  **Modern UI** - Smooth animations, shimmer loading, hero transitions
-  **Infinite Scroll** - Smart pagination for seamless browsing
-  **Clean Architecture** - Maintainable, testable, scalable code
-  **BLoC Pattern** - Predictable state management
-  **Offline Support** - Network monitoring and error handling

### Prerequisites
- Flutter SDK 3.11.0+
- NewsAPI key from [newsapi.org](https://newsapi.org/register)
- create account in [newsapi.org](https://newsapi.org/register) and get an api key
- create .env file in root directory and put it in API_KEY='YOUR_API_KEY_HERE'

##  Architecture

```
lib/
├── core/                 # Core utilities, services, base classes, shared widgets
├── config/              # Theme, routing
└── features/            # Feature modules (home, detail, favorites, search)
```

**Pattern:** Clean Architecture + BLoC (Cubit)

##  Tech Stack

| Category | Libraries |
|----------|-----------|
| **State Management** | flutter_bloc, equatable |
| **Networking** | dio |
| **Database** | sqflite |
| **Caching** | shared_preferences, cached_network_image |
| **Navigation** | go_router |
| **DI** | get_it |
| **UI** | shimmer, webview_flutter |
| **Utils** | intl, connectivity_plus, url_launcher |

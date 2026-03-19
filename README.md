# GroceWise Flutter App

A grocery price comparison app that helps users find the cheapest prices across supermarkets.

## Screens Implemented

| Screen | File | Description |
|--------|------|-------------|
| Splash | `splash_screen.dart` | Animated logo with tagline |
| Welcome | `welcome_screen.dart` | Wavy blob background + CTA buttons |
| Register | `register_screen.dart` | Sign up form with social login |
| Login | `login_screen.dart` | Login form with remember me |
| Home | `home_screen.dart` | Grocery list with cheapest prices |
| Search | `search_screen.dart` | Search + multi-store price results |
| Product Detail | `product_screen.dart` | Product info, store prices, qty control |
| My Lists | `lists_screen.dart` | All shopping lists with totals |
| List Detail | `shopping_list_detail_screen.dart` | Per-store tabs, item management, share |
| Settings | `settings_screen.dart` | Profile, password, theme, logout |
| Edit Profile | `edit_profile_screen.dart` | Edit name & email |
| Change Password | `change_password_screen.dart` | Update password |

## Themes
- **Dark mode**: Navy blue (`#0D1B2A`) background, purple accents (`#7C4DFF`)
- **Light mode**: Golden yellow (`#FFC107`) background, black accents
- Toggle via Settings → Change theme

## Setup

### Prerequisites
- Flutter SDK 3.x+
- VS Code with Flutter extension
- Android emulator or physical device

### Steps

```bash
# 1. Navigate to the project folder
cd grocewise

# 2. Get dependencies
flutter pub get

# 3. Run the app
flutter run
```

### If you get font errors
```bash
flutter pub get
flutter clean
flutter run
```

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── theme/
│   └── app_theme.dart                 # Dark/light themes + color palette
├── models/
│   ├── models.dart                    # Data models + sample data
│   └── app_state.dart                 # State management
└── screens/
    ├── splash_screen.dart
    ├── welcome_screen.dart
    ├── login_screen.dart
    ├── register_screen.dart
    ├── home_screen.dart
    ├── search_screen.dart
    ├── product_screen.dart
    ├── lists_screen.dart
    ├── shopping_list_detail_screen.dart
    ├── settings_screen.dart
    ├── edit_profile_screen.dart
    └── change_password_screen.dart
```

## Navigation Flow

```
SplashScreen
    └── WelcomeScreen
        ├── RegisterScreen → HomeScreen
        └── LoginScreen → HomeScreen
                └── Bottom Nav (Home / Search / List)
                    ├── HomeTab → ProductScreen → Add to List dialog
                    ├── SearchScreen → ProductScreen
                    ├── ListsScreen → ShoppingListDetailScreen (share modal)
                    └── SettingsScreen (via gear icon)
                        ├── EditProfileScreen
                        └── ChangePasswordScreen
```

## Dependencies

```yaml
google_fonts: ^6.1.0   # Poppins font
cupertino_icons: ^1.0.2
```

## Notes for Connecting Backend
- Replace `SampleData` in `models/models.dart` with API calls
- Add Firebase Auth or your auth service in login/register screens
- Replace placeholder store logos with actual SVG/PNG assets

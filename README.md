# social_mate

Social Mate is a cross‑platform social‑networking Flutter app built with Supabase backend services. Users can **authenticate (email/password or Google)**, go through an **onboarding tour**, create posts, follow people, browse a discovery feed, chat in real‑time, view and add stories, manage their profile, and receive push notifications. The UI adapts to **Arabic/English** and supports **light & dark themes** with persisted preferences.

---

## 📱 Project Overview

Social Mate is a cross‑platform social‑networking Flutter app built with Supabase backend services.  
Users can **authenticate (email/password or Google)**, go through an **onboarding tour**, create posts, follow people, browse a discovery feed, chat in real‑time, view and add stories, manage their profile, and receive push notifications.  
The UI adapts to **Arabic/English** and supports **light & dark themes** with persisted preferences.

---

## ✨ Features

- **Authentication**
  - Email/password sign‑up & sign‑in
  - Google sign‑in
  - Auth state management with `AuthCubit`
- **Onboarding flow**
  - Four‑page introduction shown the first time
  - State persisted via `OnboardingCubit`
- **Localization**
  - Full Arabic and English support
  - Strings defined in `intl_en.arb` / `intl_ar.arb`
  - Language selection via `LocalizationCubit`
- **Theme switching**
  - Light / dark / system themes
  - `ThemeCubit` + `HydratedCubit` for persistence
- **Core social features**
  - Feed discovery
  - Creating & editing posts (text, images, videos)
  - Stories
  - Follow/followers, follow requests
  - Profile (public/private), edit profile, saved posts
  - Real‑time chats with Supabase
  - Notifications (push via Supabase function)
- **Additional utilities**
  - Internet connectivity status
  - File picking & native sharing
  - Supabase storage & database services
  - Native splash screens
  - Google sign‑in integration
  - DOTENV support for secrets

---

## 🛠️ Technologies Used

- **Flutter SDK**: environment `sdk: ^3.9.2` (see `pubspec.yaml`)
- **State management**: `flutter_bloc`/`hydrated_bloc` (Cubit pattern)
- **Routing**: custom `AppRouter` with named routes
- **Localization**: `flutter_localization` + Intl (`flutter_intl`)
- **Theme management**: `ThemeCubit` with `ThemeMode` states
- **Other dependencies** (from `pubspec.yaml`):
  `auto_size_text`, `cached_network_image`, `connectivity_plus`, `dio`, `file_picker`, `firebase_core/messaging`, `flutter_dotenv`, `flutter_screenutil`, `flutter_svg`, `get`, `google_sign_in`, `hydrated_bloc`, `image_picker`, `intl`, `loading_animation_widget`, `open_filex`, `path_provider`, `persistent_bottom_nav_bar_v2`, `shared_preferences`, `skeletonizer`, `supabase_flutter`, `timeago`, `video_player`, `visibility_detector`, …and more.
- **Architecture**: feature‑based clean architecture –  
  `core/` for shared utilities, `features/` split into sub‑modules such as `auth`, `chat`, `discover`, `home`, `profile`, etc.

---

## 📸 Screenshots

### 🌐 Arabic Localization

| Screenshot                                                            | Description                |
| --------------------------------------------------------------------- | -------------------------- |
| ![Arabic Add Post](assets/screens/arabic_screens/arabic_add_post.png) | Add Post (Arabic)          |
| ![Arabic Discover](assets/screens/arabic_screens/arabic_discover.png) | Discover feed (Arabic)     |
| ![Arabic Drawer](assets/screens/arabic_screens/arabic_drawer.png)     | Navigation drawer (Arabic) |
| ![Arabic Home](assets/screens/arabic_screens/arabic_home.png)         | Home screen (Arabic)       |
| ![Arabic Profile](assets/screens/arabic_screens/arabic_profile.png)   | Profile screen (Arabic)    |

### ☀️ Light Mode

| Screenshot                                                                                                                                                                                                                                            | Page                           |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| ![Add post 1](assets/screens/light_screens/light_add_post_1.png) / ![Add post 2](assets/screens/light_screens/light_add_post_2.png)                                                                                                                   | Add post pages                 |
| ![Chats](assets/screens/light_screens/light_chats.png) / ![Chats loading](assets/screens/light_screens/light_chats_loading.png)                                                                                                                       | Chats list & loading           |
| ![Comments](assets/screens/light_screens/light_comments.png)                                                                                                                                                                                          | Comments view                  |
| ![Discover](assets/screens/light_screens/light_discover.png)                                                                                                                                                                                          | Discover feed                  |
| ![Drawer](assets/screens/light_screens/light_drawer.png)                                                                                                                                                                                              | Drawer                         |
| ![Edit profile](assets/screens/light_screens/light_edit_profile.png)                                                                                                                                                                                  | Edit profile                   |
| ![Followers](assets/screens/light_screens/light_followers.png)                                                                                                                                                                                        | Followers list                 |
| ![Following](assets/screens/light_screens/light_following.png)                                                                                                                                                                                        | Following list                 |
| ![Follow requests](assets/screens/light_screens/light_follow_requests.png)                                                                                                                                                                            | Follow requests                |
| ![Google sign-in](assets/screens/light_screens/light_google_sign.png)                                                                                                                                                                                 | Google sign‑in screen          |
| ![Home 1](assets/screens/light_screens/light_home_1.png) / ![Home 2](assets/screens/light_screens/light_home_2.png) / ![Home 3](assets/screens/light_screens/light_home_3.png) / ![Home loading](assets/screens/light_screens/light_home_loading.png) | Home feed variations           |
| ![Language select](assets/screens/light_screens/light_lang_select.png)                                                                                                                                                                                | Language selection             |
| ![Native splash](assets/screens/light_screens/light_native_splash_.png)                                                                                                                                                                               | Splash screen                  |
| ![Notification permission](assets/screens/light_screens/light_notififcation_permission.png)                                                                                                                                                           | Notification permission prompt |
| ![Onboarding pages](assets/screens/light_screens/light_onboearding_1.png) … ![Onboarding 4](assets/screens/light_screens/light_onboearding_4.png)                                                                                                     | Onboarding pages               |
| ![Private profile](assets/screens/light_screens/light_private_profile.png) / ![Public profile](assets/screens/light_screens/light_public_profile.png)                                                                                                 | Profile views                  |
| ![Saved posts](assets/screens/light_screens/light_saved_posts.png)                                                                                                                                                                                    | Saved posts                    |
| ![Sign in](assets/screens/light_screens/light_sign_in.png) / ![Sign up](assets/screens/light_screens/light_sing_up.png)                                                                                                                               | Authentication screens         |
| ![Single chat](assets/screens/light_screens/light_single_chat.png)                                                                                                                                                                                    | One‑to‑one chat                |
| ![Story 1](assets/screens/light_screens/light_story_1.png) / ![Story 2](assets/screens/light_screens/lgiht_story_2.png)                                                                                                                               | Story interface                |
| ![Theme select](assets/screens/light_screens/light_theme_select.png)                                                                                                                                                                                  | Theme selection                |
| ![User post](assets/screens/light_screens/light_user_post.png)                                                                                                                                                                                        | User post view                 |
| ![Discover search](assets/screens/light_screens/lgiht_discover_search.png)                                                                                                                                                                            | Discover search page           |
| ![Real time chatting](assets/screens/light_screens/real_time_chatting.png)                                                                                                                                                                            | Real‑time chat example         |

### 🌙 Dark Mode

| Screenshot                                                                                                                                                                           | Page            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------- |
| ![Add post 1](assets/screens/dark_screens/dark_add_post_1.png) / ![Add post 2](assets/screens/dark_screens/dark_add_post_2.png)                                                      | Add post        |
| ![Chats](assets/screens/dark_screens/dark_chats.png) / ![Chats loading](assets/screens/dark_screens/dark_chats_loading.png)                                                          | Chats list      |
| ![Comments](assets/screens/dark_screens/dark_comments.png)                                                                                                                           | Comments        |
| ![Discover](assets/screens/dark_screens/dark_discover.png)                                                                                                                           | Discover feed   |
| ![Drawer](assets/screens/dark_screens/dark_drawer.png)                                                                                                                               | Drawer          |
| ![Followers](assets/screens/dark_screens/dark_followers.png)                                                                                                                         | Followers       |
| ![Follow requests](assets/screens/dark_screens/dark_follow_requests.png)                                                                                                             | Follow requests |
| ![Google sign-in](assets/screens/dark_screens/dark_google_sign.png)                                                                                                                  | Google sign‑in  |
| ![Home 1](assets/screens/dark_screens/dark_home_1.png) / ![Home 2](assets/screens/dark_screens/dark_home_2.png) / ![Home loading](assets/screens/dark_screens/dark_home_loading.png) | Home            |
| ![Native splash](assets/screens/dark_screens/dark_native_splash.png)                                                                                                                 | Splash          |
| ![Private profile](assets/screens/dark_screens/dark_private_profile.png)                                                                                                             | Private profile |
| ![Public chat](assets/screens/dark_screens/dark_public_chat.png)                                                                                                                     | Public chat     |
| ![Saved posts](assets/screens/dark_screens/dark_saved_posts.png)                                                                                                                     | Saved posts     |
| ![Sign in](assets/screens/dark_screens/dark_sign_in.png) / ![Sign up](assets/screens/dark_screens/dark_sign_up.png)                                                                  | Auth screens    |
| ![Single chat](assets/screens/dark_screens/dark_single_chat.png)                                                                                                                     | Chat            |
| ![Story](assets/screens/dark_screens/dark_story.png)                                                                                                                                 | Story           |
| ![User posts](assets/screens/dark_screens/dark_user_posts.png)                                                                                                                       | User post       |
| ![Misc unread messages](assets/screens/light_screens/light_unread_mesgaes.png) / ![Launcher icon](assets/screens/light_screens/luncher_icon.png)                                     | Misc. assets    |

> 📁 _Images are grouped by folder; refer to filenames when adding new screenshots to maintain consistency._

---

## 📂 Project Structure

```
lib/
 ├── core/                 # shared utilities, services, cubits, theme
 │   ├── cubits/           # Bloc/Cubit state managers
 │   ├── models/
 │   ├── pages/            # Common pages (onboarding, etc.)
 │   ├── services/         # API, Supabase, native helpers
 │   ├── utils/            # constants, routes, theme helpers
 │   └── views/            # shared widgets
 ├── features/             # feature modules
 │   ├── auth/             # authentication flows
 │   ├── chat/             # messaging
 │   ├── discover/         # discovery feed
 │   ├── followRequest/
 │   ├── home/             # home feed
 │   ├── profile/          # user profiles, settings, theme/lang
 │   └── story/            # stories functionality
 ├── generated/            # localization/generated code
 ├── l10n/                 # ARB files for translations
 ├── firebase_options.dart
 ├── main.dart             # app entry point, BlocProviders
 └── root.dart             # root widget with router
```

Each `features/*` directory typically contains its own `cubit`, `data`, `models`, `services`, and `views` subfolders, following a Clean‑Architecture style breakdown.

---

## 🚀 Getting Started

### Prerequisites

- Install [Flutter](https://flutter.dev/docs/get-started/install) (SDK ≥ 3.9.2).
- A suitable IDE (VS Code, Android Studio) with Flutter & Dart plugins.
- Optional: Android/iOS emulator or physical device.
- Configure `.env` file with Supabase keys (refer to `pubspec.yaml` assets).

### Installation

```bash
git clone <repository-url>
cd social_mate
flutter pub get
flutter run
```

### 🎯 How to Use

1. **Entry point**: `lib/main.dart` sets up `BlocProviders` (Auth, Theme, Onboarding, Localization, Internet) and launches `Root` router.
2. **Switch languages**: use the language selector in the profile/settings page; `LocalizationCubit` updates `Locale`.
3. **Toggle themes**: open theme selection (profile > settings) to pick Light/Dark/System; `ThemeCubit` persists choice.
4. **User flows**:
   - New user: browse onboarding → sign up / login → explore feed.
   - Create posts/stories or follow other users.
   - Tap chat icon to start conversations; messages stored via Supabase.
   - Accept follow requests from the “Follow Requests” tab.
   - Edit profile, view saved posts, manage privacy.
   - Receive push notifications for chat/messages via Supabase function in `supabase/functions/push`.

### 🧪 Testing

A growing suite of unit tests lives under the `test/` directory. The current effort focuses on the **home feature**:

- `test/features/home/services/home_services_test.dart` covers `HomeServicesImpl`.
  - Uses **mockito** to inject a fake `SupabaseDatabaseServices` instance.
  - Exercises `fetchStories`, `fetchUserStories`, `addStory`, and `deleteStory` success/error flows.
  - Mocks are generated via `build_runner` (see below).

> The `home_cubit` tests were previously present but have been removed; feel free to re‑add them or author new ones around the cubit when needed.

#### Running tests

```bash
# install dependencies
flutter pub get

# generate mocks (run anytime you add new @GenerateMocks annotations)
flutter pub run build_runner build --delete-conflicting-outputs

# run all tests
flutter test

# run a specific file
flutter test test/features/home/services/home_services_test.dart
```

#### Dependencies used in tests

The project includes the following dev dependencies for testing:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mockito: ^5.4.2
  build_runner: ^2.4.6
  bloc_test: ^9.1.0
```

You can add more packages as the test suite expands (e.g. `mocktail`, `integration_test`).

The rest of the README remains unchanged — continue adding widget tests, integration tests, or CI steps as the codebase grows.

---

## 🤝 Contributing

1. Fork the repo.
2. Create a feature branch: `git checkout -b feature/foo`.
3. Commit changes: `git commit -m "Add foo"`.
4. Push and open a pull request.
5. Ensure code follows lint rules (`flutter analyze`) and update/add tests.

Please keep architecture boundaries (core vs feature) intact and update `pubspec.yaml` for new dependencies.

---

## 📄 License

No license file detected.  
Consider adding an [MIT](https://choosealicense.com/licenses/mit/) or other open‑source license to clarify usage and contributions.

---

> **Tip:** This README is automatically generated from the current source tree.  
> Add new assets, features, or dependencies and re‑run the generator to keep it up‑to‑date.

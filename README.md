# Mini Market

Mini Market is a small Flutter final project. The topic is a simple online shop.
The app shows products from an external API, lets the user add items to cart,
save favorite products locally, and create orders in Firestore.


## Main Features

- Product catalog from DummyJSON API
- Product details page
- Shopping cart with item count
- Favorite products saved with Drift SQLite
- Dark theme setting saved with Shared Preferences
- Order history saved in Cloud Firestore
- Navigation with go_router
- State management and dependency injection with Riverpod
- Responsive product grid with Slivers

## Project Structure

- `lib/domain` - simple app models
- `lib/data` - API, Drift database, repositories
- `lib/presentation` - screens and widgets
- `lib/app_providers.dart` - Riverpod providers
- `lib/router.dart` - app routes

## Setup

Install packages:

```bash
flutter pub get
```

Generate Drift files if needed:

```bash
dart run build_runner build
```

Run the app:

```bash
flutter run
```

## Firebase Setup

Firebase is connected to project `flutter-final-f2191`.
Cloud Firestore must be enabled in Firebase Console for order history.
Local favorites stored in SQLite Database (locally) while Order history is stored in Cloud Firestore (remotely).

## Used Packages

- `flutter_riverpod`
- `go_router`
- `chopper`
- `drift`
- `shared_preferences`
- `firebase_core`
- `cloud_firestore`


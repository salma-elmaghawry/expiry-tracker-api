# Expiry Tracker app: architecture notes

Flutter client for the ExpiryTracker API, for web and Android. Built on the flutter-foundation structure, with two changes: **go_router** instead of `onGenerateRoute`, and **Clean Architecture in every layer**, so the domain layer also holds the repository contracts and use cases.

## Folder layout

```text
lib/
├── main.dart                 bootstrap: EasyLocalization, .env (mobile only), get_it, runApp
├── app.dart                  ScreenUtilInit, ThemeCubit, MaterialApp.router
├── core/
│   ├── animations/           AppAnimations presets and animated widgets
│   ├── bloc/base_bloc.dart   BaseState: status, message, isLoading, ...
│   ├── const/                AppAssets, AppBreakpoints
│   ├── error_handling/       Failure types and ErrorMapper (dio aware)
│   ├── helpers/              spacing, validators, ui helpers
│   ├── injection/            get_it registrations
│   ├── network/              ApiConfig (base URL) and DioClient
│   ├── routes/               Routes (paths) and AppRouter (GoRouter)
│   ├── theme/                AppColors, AppTheme, ThemeCubit
│   ├── usecase/              UseCase<T, Params> and NoParams
│   ├── utils/                AppTextStyles
│   └── widgets/              MainShell, NotFoundScreen, shared widgets
└── features/<feature>/
    ├── data/
    │   ├── datasources/      remote data source contract + dio implementation
    │   ├── models/           JSON models: fromJson, toJson, toEntity()
    │   └── repositories/     repository implementation: try/catch, ErrorMapper, Either
    ├── domain/
    │   ├── entities/         plain Equatable classes, no JSON
    │   ├── repositories/     abstract repository contract
    │   └── usecases/         one class per action, calls the repository
    └── presentation/
        ├── cubit/            Cubit + State (extends BaseState)
        ├── screens/
        └── widgets/
```

Features that only show UI (splash, settings today) keep just `presentation/`.

## Dependency direction

```text
presentation  ──►  domain  ◄──  data
   Cubit          UseCase        RepositoryImpl
                  Repository     RemoteDataSource
                  (abstract)     Models
```

- **domain** depends on nothing in the app except `core/error_handling` and `core/usecase`. It does not import dio or Flutter widgets.
- **data** implements the domain contracts. Data sources throw raw exceptions; only the repository implementation catches them and returns `Either<Failure, T>`.
- **presentation** talks to use cases only, never to repositories or data sources directly. Cubits `fold` the `Either` into state.

## Routing (go_router)

- Paths live in `core/routes/routes.dart`; the `GoRouter` lives in `core/routes/app_router.dart` and is a lazy singleton in get_it, so a hot reload never rebuilds it.
- The four tabs are a `StatefulShellRoute.indexedStack`, so every tab keeps its own scroll position and state when you switch.
- `MainShell` shows a bottom `NavigationBar` under 840 px wide and a side `NavigationRail` above it (web on a PC).
- `/` redirects to `/splash`. Unknown paths go to `NotFoundScreen` through `errorBuilder`.
- Navigate with go_router's own extensions: `context.go(Routes.x)` to switch place, `context.push(...)` to stack a page, `context.pop()` to go back. The foundation's `core/helpers/extensions.dart` was removed because its `pushNamed` and `pop` clash with go_router's.

## Design

- Source of truth: the "Expiry Tracker" design canvas (tokens, component sheet, interaction notes, mobile, desktop, Arabic and dark artboards).
- Color tokens live in `AppColors` and `AppTheme` (light and dark). Urgency and status colors live in the `StatusColors` theme extension: read them with `context.statusColors.forUrgency(...)` and `forStatus(...)`.
- Text uses Nunito with IBM Plex Sans Arabic as the fallback for Arabic. Titles and labels use the `ExtraBold` (w800) getters in `AppTextStyles`. Money and counts use `.tabular()`.

## Batches screen

- Filters live in the URL: `/batches?status=Active&urgency=Expired&from=dashboard`. The route builds `BatchFilters` from the query, so the web Back button and a page refresh keep the filter.
- The cubit loads every batch once. Status, urgency and search filter on the device, which keeps the chip counts right and makes switching filters instant.
- `from=dashboard` shows the "From Dashboard" banner with the count and value at risk.
- Tapping an Active or Discounted batch opens one bottom sheet that moves between steps: chooser, Sell, Discount, Waste, and the "already sold or wasted" step when the API answers 409.

## Barcode scanner

- `mobile_scanner` shows the camera and reads barcodes with Google ML Kit, on the phone, without internet.
- `ScannerScreen` lives at `/scan`, outside the shell, so it covers the bottom bar. Open it with `await context.push<String>(Routes.scan)`: it returns the barcode, `ScannerScreen.enterManually` when staff tap "Enter manually", or `null` on Back.
- The `CAMERA` permission is declared in `AndroidManifest.xml`; the package asks for it the first time the scanner opens. If staff deny it, the screen shows a message with "Try again".
- Phone only. On web the scan button is hidden and the barcode field is autofocused, because a USB scanner types the code like a keyboard.

## Talking to the API

- `ApiConfig.baseUrl` decides where requests go, and `DioClient` reads it on every request, so changing the server address takes effect without restarting.
- Order: the `server_url` saved in SharedPreferences (Settings, coming later), then the default.
- Default on **web**: the same host that served the page, port 5291 (`http://localhost:5291` during development).
- Default on **Android**: `API_BASE_URL` from `.env`, or `http://10.0.2.2:5291` (the Android emulator's address for the host PC).
- `.env` is not committed. Copy `.env.example` to `.env` and put the PC's Wi-Fi IP in it.
- Android allows plain `http` (`usesCleartextTraffic`) because the API runs on the store LAN without TLS.

## Shared API vocabulary (`core/domain`)

- The API's enums (`Category`, `BatchStatus`, `WasteReason`, `ExpiryBucket`, `BatchActionType`) live in `core/domain/enums`, because several features use them.
- Dart enums are lowerCamelCase (`meatAndPoultry`) and the API sends PascalCase (`MeatAndPoultry`). `apiName`, `enumFromApi` and `tryEnumFromApi` in `core/domain/api_enum.dart` convert between the two, so no feature writes its own mapping.
- Labels for the UI come from `core/helpers/enum_labels.dart` (`category.label`), backed by translation keys named after the enum value.
- Money stays in piasters everywhere. `Money.format` shows it in EGP for the current locale, and `Money.tryParsePiasters` reads what staff type, including Arabic digits.
- `expiryDate` is a calendar date, parsed to UTC midnight so "days left" never shifts with the time zone. `createdAt` and `actionAt` are real UTC moments.

## Errors

`ErrorMapper` turns dio errors into typed failures with localized messages:

| Situation | Failure |
|---|---|
| Timeout, connection refused, CORS blocked (web) | `NetworkFailure` |
| 400 | `ValidationFailure`, with the API's field errors keyed by JSON field name |
| 404 | `NotFoundFailure` |
| 409 | `ConflictFailure` (batch already sold or wasted) |
| Other status codes, unreadable JSON | `ServerFailure` |

## Sizing on web

The foundation designs for 360 × 690. On a wide browser window that scales every `.w` value by about 4, so `app.dart` switches the ScreenUtil design size to 1280 × 800 when the window is at least 840 px wide.

## Localization note

`MainShell` reads `context.locale` at the start of `build`. That registers a dependency on EasyLocalization, so the tab labels rebuild immediately when the language changes.

## Known follow-ups

- Fonts come from Google Fonts at runtime. If the store PC or phone has no internet, text falls back to the system font. Bundling Nunito as an asset fixes that.
- No authentication yet (planned for v2).

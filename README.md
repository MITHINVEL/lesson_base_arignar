# lesson_base_arignar

Responsive lesson demo that can run standalone or inside the Arignar embedded
vendor portal.

## Running the Flutter app directly

```bash
flutter pub get
flutter run -d chrome
```

## Embedded portal workflow

The repository includes `embeddedWeb/`, a small Node/Express container that
simulates the vendor portal (22 % sidebar + 78 % iframe) and handles the
`postMessage` bridge.

### One-command startup (Windows)

```powershell
.\start_embedded_dev.ps1
```

The script:

- installs Node dependencies (first run only)
- starts the Flutter web server on `http://localhost:5000`
- serves the portal shell on `http://localhost:58257`

Open `http://localhost:58257/sample.html` to see the embedded experience.

### Manual commands (macOS/Linux)

```bash
# Terminal 1 – Flutter web
flutter run -d web-server --web-port=5000 --web-hostname=0.0.0.0

# Terminal 2 – Embedded portal
cd embeddedWeb
npm install            # first run only
node server.js
```

Then browse to `http://localhost:58257/sample.html`.

### Message bridge expectations

The Flutter app now emits and handles the same status events as the portal:

| Direction        | Event                                      | Purpose                     |
| ---------------- | ------------------------------------------ | --------------------------- |
| Flutter → Portal | `ARIGNAR_INITIATED`                        | iframe boot complete        |
| Portal → Flutter | `INIT_AUTH`                                | supplies auth token         |
| Flutter → Portal | `AUTH_SUCCESS`                             | auth handshake successful   |
| Portal → Flutter | `INIT_PROFILE`                             | supplies profile/class data |
| Flutter → Portal | `ARIGNAR_PROFILE_LOADED`                   | profile cached              |
| Portal → Flutter | `INIT_CHAPTER` / `INIT_READY_STATE`        | load chapter metadata       |
| Flutter → Portal | `ARIGNAR_CHAPTER_LOADED` + `ARIGNAR_READY` | lesson rendered             |

While embedded, chapter metadata (title, locale, etc.) is reflected in the UI.

### Responsive behaviour

- The Flutter surface constrains itself to 78 % width (matching the sample
  sidebar layout) and clamps the lesson container to ≤ 1080 px so OS zoom levels
  like 125 % do not overflow.
- Desktop layout uses a scrollable left rail, preventing button overflow in
  shorter viewports.
- Tablet/mobile breakpoints stack the content vertically with automatic scroll.

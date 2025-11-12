# macOS Preview Setup Guide

This guide explains how to run the Arignar Flutter app in macOS preview mode with external control via Node.js.

## Architecture Overview

The macOS preview implementation uses a different architecture than the web version:

- **Web Version**: Uses `postMessage` API for iframe communication
- **macOS Version**: Uses HTTP server for native app communication

```
┌─────────────────────┐         HTTP          ┌─────────────────────┐
│                     │    (localhost:8765)    │                     │
│  Node.js Controller │ ◄──────────────────► │  Flutter macOS App  │
│  (macosController)  │                        │  (macosPreviewMain) │
│                     │                        │                     │
└─────────────────────┘                        └─────────────────────┘
         │                                              │
         │                                              │
         ▼                                              ▼
    Token Service                                  Amplify Auth
    (AWS API)                                      Custom Auth Flow
```

## Setup Instructions

### 1. Prerequisites

- Flutter SDK installed and configured for macOS
- Node.js 16+ installed
- `.env` file with `API_KEY` configured in `embeddedWeb/` directory

### 2. Install Dependencies

```bash
cd embeddedWeb
npm install
```

### 3. Start the Flutter macOS App

From the project root:

```bash
# Run with macOS preview main
flutter run -d macos -t lib/macosPreviewMain.dart
```

The Flutter app will:

- Start an HTTP server on `localhost:8765`
- Wait for authentication messages
- Display status on screen

### 4. Start the Node.js Controller

In a separate terminal:

```bash
cd embeddedWeb
node macosController.js
```

This starts an interactive CLI for controlling the Flutter app.

## Using the Controller

### Interactive Commands

```
flutter> help                    # Show all commands
flutter> init chapter1           # Full initialization with chapter 1
flutter> auth                    # Authenticate only
flutter> profile                 # Load profile
flutter> chapter chapter2        # Load chapter 2
flutter> reset                   # Reset to ready state
flutter> logout                  # Logout
flutter> status                  # Check Flutter status
flutter> list                    # List available chapters
flutter> exit                    # Exit controller
```

### Example Workflow

```bash
# 1. Start controller
node macosController.js

# 2. Initialize with chapter 1 (full flow)
flutter> init chapter1

# 3. Load different chapter
flutter> chapter chapter2

# 4. Reset to ready state
flutter> reset

# 5. Load another chapter
flutter> chapter chapter1
```

## Message Flow

### 1. Initialization Flow

```
Controller                    Flutter App
    │                             │
    │──── INIT_AUTH ─────────────►│
    │                             │ (Authenticate with Cognito)
    │◄─── AUTH_SUCCESS ───────────│
    │                             │
    │──── INIT_PROFILE ───────────►│
    │                             │ (Load user profile)
    │◄─── ARIGNAR_PROFILE_LOADED ─│
    │                             │
    │──── INIT_CHAPTER ───────────►│
    │                             │ (Load chapter content)
    │◄─── ARIGNAR_CHAPTER_LOADED ─│
    │                             │
```

### 2. Message Types

**From Controller to Flutter:**

- `INIT_AUTH` - Start authentication with token
- `INIT_PROFILE` - Load user profile
- `INIT_CHAPTER` - Load chapter content
- `INIT_READY_STATE` - Reset to ready state
- `INIT_LOGOUT` - Logout user

**From Flutter to Controller:**

- `ARIGNAR_INITIATED` - App started and ready
- `AUTH_SUCCESS` - Authentication successful
- `AUTH_ERROR` - Authentication failed
- `ARIGNAR_PROFILE_LOADED` - Profile loaded
- `ARIGNAR_CHAPTER_LOADED` - Chapter loaded

## Testing Different Display Settings

The macOS version maintains the same responsive layout system as the web version:

### Window Sizes to Test

```bash
# Compact layout (phone-like)
# Resize window to: 375x667

# Tablet layout
# Resize window to: 768x1024

# Desktop layout
# Resize window to: 1024x768
```

The app will automatically adapt to the window size and log responsive debug info to console.

## Configuration

### Chapter Data Structure

Edit `macosController.js` to add/modify chapters:

```javascript
const CHAPTERS = {
  chapter1: {
    chapterId: "1",
    referenceId: "852b69ae-190c-498e-ba69-ab3787f4e715",
    referenceType: "Chapter",
    classCode: "KG00A2",
    locale: "en",
    title: "Chapter 1",
  },
  // Add more chapters...
};
```

### Authentication

The controller uses the same token service as the web version:

```javascript
const API_KEY = process.env.API_KEY;
const username = "DM-KG00A2"; // Change as needed
```

## Troubleshooting

### Flutter app not responding

```bash
# Check if Flutter app is running
flutter> status

# If not ready, restart Flutter app
# In Flutter terminal: press 'r' to hot reload
```

### Port already in use

```bash
# Kill process using port 8765
lsof -ti:8765 | xargs kill -9

# Restart Flutter app
```

### Authentication errors

```bash
# Check API_KEY is set
echo $API_KEY

# Check .env file
cat embeddedWeb/.env

# Verify token service is accessible
curl -X POST https://yfaniwtlpb.execute-api.us-east-1.amazonaws.com/target-account/tokens \
  -H "Content-Type: application/json" \
  -H "x-api-key: YOUR_API_KEY" \
  -d '{"userName":"DM-KG00A2","ttlInSeconds":3600,"requestedBy":"test"}'
```

### Connection refused

```bash
# Ensure Flutter app is running and server started
# Check console for: "🚀 macOS Preview Server listening on http://localhost:8765"

# Test connection
curl http://localhost:8765/status
```

## Development Tips

### Hot Reload

The Flutter app supports hot reload:

- Press `r` in Flutter terminal for hot reload
- Press `R` for hot restart
- Controller connection persists through hot reload

### Debug Logging

Both Flutter and Node.js log detailed information:

**Flutter logs:**

```
🔍 MACOS PREVIEW APP - WAITING SCREEN
📐 Screen: 820x1180
📱 Breakpoint: tablet
```

**Controller logs:**

```
📤 Sending message to Flutter: INIT_AUTH
✅ Message sent successfully: INIT_AUTH
```

### Custom Modifications

To add new message types:

1. Add handler in `macosPreviewMain.dart`:

```dart
case 'YOUR_MESSAGE_TYPE':
  // Handle message
  break;
```

2. Add method in `macosController.js`:

```javascript
async yourMethod() {
  await this.sendMessage('YOUR_MESSAGE_TYPE', { /* data */ });
}
```

## Comparison: Web vs macOS

| Feature       | Web Version                  | macOS Version       |
| ------------- | ---------------------------- | ------------------- |
| Communication | postMessage                  | HTTP Server         |
| Platform      | Browser iframe               | Native macOS        |
| Port          | N/A                          | 8765                |
| Layout        | Constrained by vendor portal | Full window control |
| Hot Reload    | Requires page refresh        | Native support      |
| Debugging     | Browser DevTools             | Flutter DevTools    |

## Next Steps

- Add more chapters to test different content
- Test with different user profiles
- Implement lesson/question navigation
- Add automated testing scripts
- Create display setting presets

## Support

For issues or questions:

1. Check Flutter console for errors
2. Check Node.js console for connection issues
3. Verify Amplify configuration
4. Test token service independently

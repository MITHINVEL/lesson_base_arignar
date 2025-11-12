# Arignar Embedded Portal Demo

This is a simple demo of how Arignar App can be embedded in a website.

## Prerequisites

- Node.js (v14 or higher)
- npm

### Arignar Demo users

Work with the Arignar team to get the demo users to be used in this demo.

### API_KEY

Create a new .env file in the root of the project and set the API_KEY.

## Setup

1. Clone this repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the server:
   ```bash
   npm start
   ```

The server will run at `http://localhost:3000`.

4. Launch the app

http://localhost:3000/sample.html

## API Endpoint

The API endpoint from sample.html is pointing to the express server running at `http://localhost:3000/api/token`.

In real world, this endpoint will be hosted on a server managed by your company and will be called from your website.

### Get Token

https://t4b67cht52.execute-api.us-east-1.amazonaws.com/dev/tokens

This is the AWS API Gateway endpoint that will be called by the express server. The API Gateway is configured to use the API_KEY from the .env file.

To this endpoint, you need to pass the username as a query parameter.

### Get Token Response

The response will be a JSON object with the token. You can use this token to pass to the Arignar App.

### Javascript Arignar App Integration

The development Preview of Arignar App is available at https://preview.arignar.app

To embed the Arignar App in a website, you need to add the following code to your website:

```html
<script src="https://preview.arignar.app/arignar.js"></script>
```

This will load the Arignar App in a new window.

The below key events are emitted by Arignar App and can be handled by your website:

- ARIGNAR_INITIATED : This event is emitted when the Arignar App is initiated. You can send the token to the Arignar App in this event.
- AUTH_SUCCESS : This event is emitted when the authentication is successful.
- ARIGNAR_PROFILE_LOADED : This event is emitted when the studentprofile is loaded.
- ARIGNAR_READY : This event is emitted when the Arignar App is ready.
- AUTH_ERROR : This event is emitted when the authentication fails.

You can send the below messages to the Arignar App from your website:

- INIT_AUTH : This message is used to send the token to the Arignar App and complete the authentication process.
- INIT_PROFILE : This message is used to send the chapterId to the Arignar App and load the studentprofile.
- INIT_CONTENT : This message is used to send the contentId to the Arignar App and load the content. INIT_CONTENT supports loading Chapter, Lesson and Assessment.
- INIT_READY_STATE : This message is used to send the ready state to the Arignar App. This is used to reset the Arignar App to the ready state to load the next chapter.

#### A Sample sequence of events

1. User visits your website and enters the username. For this demo the username can be hardcoded in sample.html file.
2. Your website calls the API endpoint using the usernameto get the token.
3. The API endpoint calls the Arignar API Gateway to get the token.
4. The Arignar API Gateway returns the token to the API endpoint.
5. The web app loads the Arignar App in a new window and waits for the ARIGNAR_INITIATED event.
6. The Arignar App emits the ARIGNAR_INITIATED event with the token.
7. The Web app receives the ARIGNAR_INITIATED event and sends the INIT_AUTH message to the Arignar App with the token.
8. The Arignar App responds with the AUTH_SUCCESS event.
9. The Web App receives the AUTH_SUCCESS event and sends the INIT_PROFILE message to the Arignar App with the chapterId.
10. The Arignar App responds with the ARIGNAR_PROFILE_LOADED event.
11. The Web App receives the ARIGNAR_PROFILE_LOADED event and sends the INIT_CONTENT message to the Arignar App with the contentId.
12. The Arignar App responds with the ARIGNAR_CONTENT_LOADED event.
13. The Web App receives the ARIGNAR_CONTENT_LOADED event and store it.
14. The Arignar content is now successfully loaded and the user can start learning.
15. The user navingate to next chapter. In this scenario, the Web App will send the INIT_READY_STATE message to the Arignar App.
16. The Arignar App responds with the ARIGNAR_READY event.
17. The Web App receives the ARIGNAR_READY event and sends the INIT_CONTENT message to the Arignar App with the next chapterId.
18. The Arignar App responds with the ARIGNAR_CONTENT_LOADED event.
19. The Web App receives the ARIGNAR_CONTENT_LOADED event and store it.
20. The Arignar content is now successfully loaded and the user can start learning.

### JSON Data Format for Events and Messages

#### Events Emitted by Arignar App

**ARIGNAR_INITIATED**

```json
{
  "event": "ARIGNAR_INITIATED",
  "data": {
    "sessionId": "session_12345",
    "timestamp": 1645678901234
  }
}
```

**AUTH_SUCCESS**

```json
{
  "event": "AUTH_SUCCESS",
  "data": {
    "userId": "user_12345",
    "username": "demo_user",
    "authenticated": true,
    "timestamp": 1645678901234
  }
}
```

**ARIGNAR_PROFILE_LOADED**

```json
{
  "event": "ARIGNAR_PROFILE_LOADED",
  "data": {
    "userId": "user_12345",
    "username": "demo_user",
    "chapterId": "chapter_123",
    "progress": {
      "lessonsCompleted": 5,
      "assessmentsCompleted": 2,
      "overallProgress": 0.65
    },
    "timestamp": 1645678901234
  }
}
```

**ARIGNAR_CONTENT_LOADED**

```json
{
  "event": "ARIGNAR_CONTENT_LOADED",
  "data": {
    "contentId": "content_456",
    "contentType": "chapter", // or "lesson" or "assessment"
    "title": "Introduction to Machine Learning",
    "timestamp": 1645678901234
  }
}
```

**ARIGNAR_READY**

```json
{
  "event": "ARIGNAR_READY",
  "data": {
    "readyState": true,
    "timestamp": 1645678901234
  }
}
```

**AUTH_ERROR**

```json
{
  "event": "AUTH_ERROR",
  "data": {
    "error": "Invalid token",
    "errorCode": "AUTH_001",
    "timestamp": 1645678901234
  }
}
```

#### Messages Sent to Arignar App

**INIT_AUTH**

```json
{
  "message": "INIT_AUTH",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "timestamp": 1645678901234
  }
}
```

**INIT_PROFILE**

```json
{
  "message": "INIT_PROFILE",
  "data": {
    "chapterId": "chapter_123",
    "timestamp": 1645678901234
  }
}
```

**INIT_CONTENT**

```json
{
  "message": "INIT_CONTENT",
  "data": {
    "contentId": "content_456",
    "contentType": "chapter", // or "lesson" or "assessment"
    "timestamp": 1645678901234
  }
}
```

**INIT_READY_STATE**

```json
{
  "message": "INIT_READY_STATE",
  "data": {
    "readyState": true,
    "timestamp": 1645678901234
  }
}
```

### Automatic Device Width Detection

The Flutter iframe automatically detects the optimal width based on available screen space and common device profiles:

- **iPhone SE**: 375px (minimum screen: 400px)
- **Samsung Galaxy S10**: 360px (minimum screen: 400px)
- **iPhone XS Max/11 Pro Max**: 414px (minimum screen: 450px)
- **Samsung Galaxy Note 10**: 412px (minimum screen: 450px)
- **Google Pixel 5**: 393px (minimum screen: 430px)
- **iPad Mini**: 768px (minimum screen: 800px)
- **iPad Air**: 820px (minimum screen: 860px)
- **Nest Hub**: 1024px (minimum screen: 1100px)

The system automatically:

1. Calculates available width in the content area
2. Selects the largest device profile that fits
3. Applies a maximum width limit of 720px for optimal viewing
4. Sets the iframe to the calculated width for optimal Flutter rendering
5. Centers the iframe and shows a temporary device indicator
6. Responds to window resize events for dynamic adjustment

This ensures the Flutter app renders at standard device widths for consistent UI/UX across different screen sizes, while maintaining readability with a maximum width of 720px.

## Notes

In this example we are not implementing the INIT_READY_STATE directly. Rather when the user navigates to the next chapter, we are sending the INIT_READY_STATE message to the Arignar App and then on the next click of the user, we are sending the INIT_CONTENT message to the Arignar App. This will force the user to click the chapter twice to load the content. This can be improved in real implementation.

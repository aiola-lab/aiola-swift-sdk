# aiola Streaming & TTS SDK

**Version**: `0.1.0`
**Description**: A Swift SDK for interacting with the Aiola Streaming Service, featuring real-time audio streaming and processing capabilities.

---

## Features

- **Real-Time Audio Streaming**: Stream audio to the Aiola service with configurable settings.
- **Customizable Audio Configuration**: Define sample rate, channels, and chunk size for your audio streams.

---

## Installation

To install the SDK, run the following command:

Install the Aiola Swift SDK:
```bash
git clone https://github.com/aiola-lab/aiola-swift-sdk.git

swift package add https://github.com/aiola-lab/aiola-swift-sdk
```

---

### Prerequisites
- macOS with Xcode installed
- Active Aiola API credentials

---

<br><br>


# Aiola Streaming SDK

Below is a complete example of how to use the **Aiola Streaming SDK** with the device microphone to stream audio, process events, and handle transcripts in real time.

## Code Example

```swift

let bearerToken = "<your-bearer-token>" // The Bearer Token, obtained upon registration with Aiola
        
let config = StreamingConfig(
        endpoint: "<your-base-url>", // The URL of the Aiola server
        authType: "Bearer",
        authCredentials: ["token": bearerToken],
        flowId: "<your-flow-id>", // One of the IDs from the flows created for the user
        executionId: "1009", // Unique identifier to trace execution
        langCode: "en_US", // Language code for transcription
        timeZone: "UTC", // Time zone for timestamp alignment
        namespace: "/events", // Namespace for subscription: /transcript (for transcription) or /events (for transcription + LLM solution)
        transports: "websocket" // Communication method: 'websocket' for L4 or 'polling' for L7
    )

client = AiolaStreamingClient(config: config)

// Define event callbacks
func onConnect() {
    print("✅ Connection established")
    expectation.fulfill()
}

func onDisconnect(connectionDuration: TimeInterval, totalAudioSentDuration: TimeInterval) {
    print("❌ Connection closed. Duration: \(connectionDuration)ms, Total audio: \(totalAudioSentDuration)ms")
}

func onTranscript(data: Any) {
    print("📝 Transcript received: \(data)")
    expectation.fulfill()
}

func onEvents(data: Any) {
    print("📢 Events received: \(data)")
}

func onError(error: String) {
    print("⚠️ Error occurred: \(error)")
}
```

### Explanation of Configuration Parameters

| Parameter	                  | Type	     | Description                                                                                                                          |
|-----------------------------|--------------|--------------------------------------------------------------------------------------------------------------------------------------|
| `endpoint`	              | `string`     | The base URL of the Aiola server                                                                                                     |
| `authType`	              | `string`     |  The authentication type, currently supporting "Bearer".                                                                          |
| `authCredentials` 	      | `object`     |  An object containing credentials required for authentication.                                                                       |
| `authCredentials.token`   |	`string`     |  The Bearer token, obtained during registration with Aiola.                                                                               |
| `flowId`	                  |	`string`     |  A unique identifier for the specific flow created for the user.                                                                     |
| `namespace`	              |	`string`     |  The namespace to subscribe to. Use /transcript for transcription or /events for transcription + LLM integration.                    |
| `transports`	              |	`string[]`   |  The communication method. Use ['websocket'] for Layer 4 (faster, low-level) or ['polling'] for Layer 7 (supports HTTP2, WAF, etc.). |
| `executionId`	              |	`string`     |  A unique identifier to trace the execution of the session. Defaults to "1".                                                         |
| `langCode`	              |	`string`	 |  The language code for transcription. For example, "en_US" for US English.                                                           |
| `timeZone`	              |	`string`	 |  The time zone for aligning timestamps. Use "UTC" or any valid IANA time zone identifier.                                            |
| `callbacks`	              |	`object`	 |  An object containing the event handlers (callbacks) for managing real-time data and connection states                               |

<br>

### Supported Callbacks

| Callback	| Description |
|-----------|-------------|
|`onTranscript` |	Invoked when a transcript is received from the Aiola server. |
|`onError` |	Triggered when an error occurs during the streaming session. |
|`onEvents` |	Called when events (e.g., LLM responses or processing events) are received. |
|`onConnect` |	Fired when the connection to the Aiola server is successfully established. |
|`onDisconnect` |	Fired when the connection to the server is terminated. Includes session details such as duration and total audio streamed. |

---

### How It Works

1.	Endpoint:
    -	This is the base URL of the Aiola server where the client will connect.
2.	Authentication:
    -	The SDK uses Bearer for authentication. The Bearer Token must be obtained during registration with Aiola.
3.	Namespace:
    -	Determines the type of data you want to subscribe to:
    -	`/transcript`: For transcription data only.
    -	`/events`: For transcription combined with LLM solution events.
4.	Transport Methods:
    -	Choose between:
        -	`'websocket'`: For **Layer 4** communication with lower latency.
        -	`'polling'`: For **Layer 7** communication, useful for environments with firewalls or HTTP2 support.
5.	Callbacks:
    -	These are functions provided by the user to handle various types of events or data received during the streaming session.
6.	Execution ID:
    -	Useful for tracing specific execution flows or debugging sessions.
7.	Language Code and Time Zone:
    -	Ensure the transcription aligns with the required language and time zone.
  

# aiOla TTS SDK

**Version**: `0.1.0`

This example demonstrates how to use the aiOla TTS SDK to convert text into speech and save the resulting audio as a `.wav` file.

---

## How It Works

- Converts text into a `.wav` audio file using the aiOla TTS `/synthesize` endpoint.
- Allows voice selection for speech synthesis.
---

## Code Highlights

### Initialize the TTS Client

```swift
ttsClient = AiolaTTSClient(baseUrl: "<your-base-url>/api/tts", bearerToken: "<your-bearer-token>")
```

### Synthesize Speech
```swift
ttsClient.synthesize(text: "Hello, world!") { result in
    switch result {
    case .success(let audioData):
        print("✅ Received TTS audio data: \(audioData.count) bytes")
    case .failure(let error):
        XCTFail("❌ TTS request failed: \(error.localizedDescription)")
    }
}
```

### Stream Speech
```swift
ttsClient.synthesizeStream(text: "Streaming works!") { result in
    switch result {
    case .success(let audioData):
        print("✅ Received TTS stream data: \(audioData.count) bytes")
    case .failure(let error):
        XCTFail("❌ Stream request failed: \(error.localizedDescription)")
    }
}
```
